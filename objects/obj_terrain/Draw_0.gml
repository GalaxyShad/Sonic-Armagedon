
if (trn_surface != -1) {
	shader_set(sh_black_to_transparent);
	draw_surface_ext(trn_surface, x, y, 1, 1, 0, c_white, 1.0);
	shader_reset();
	buffer_get_surface(trn_surface_buffer, trn_surface, 0);	 
	
}

if (surface_exists(surface_id)) {
	surface_set_target(surface_id);
	draw_clear_alpha(c_black, 0);

	shader_set(shader_id);

	shader_set_uniform_f(shader_get_uniform(shader_id, "u_scale"), scale);
	shader_set_uniform_f(shader_get_uniform(shader_id, "u_sharpness"), sharp);
	shader_set_uniform_f(shader_get_uniform(shader_id, "u_offset"), xx, yy);
	shader_set_uniform_f(shader_get_uniform(shader_id, "u_tilt"), tilt);
	shader_set_uniform_f(shader_get_uniform(shader_id, "u_threshold"), th);
	shader_set_uniform_f(shader_get_uniform(shader_id, "u_binary"), true);
	
	draw_set_color(c_white);
	
	gpu_set_blendmode_ext(bm_one, bm_dest_alpha);
	draw_surface(surface_id, 0, 0);
	gpu_set_blendmode(bm_normal);
	
	shader_reset();
	surface_reset_target();
	
	draw_surface_stretched(
		surface_id, 
		camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), 
		256, 128);
}



if (trn_surface == -1) {
	if (trn_surface != -1) {
		surface_free(trn_surface);
		buffer_delete(buffer);
	}
	
	buffer = buffer_create(surface_width * surface_height * 4, buffer_fixed, 1);
	buffer_get_surface(buffer, surface_id, 0);	
	
	trn_surface = surface_create(surface_width, surface_height);
	buffer_set_surface(buffer, trn_surface, 0);
	
	surface_set_target(trn_surface);
	
	gpu_set_blendenable(true);
	gpu_set_blendmode(bm_min);
	draw_sprite_tiled(spr_ghz_big_tile, 0, 0, 0);
	gpu_set_blendmode(bm_normal);
	
	gpu_set_colorwriteenable(true, true, true, false);
	
	var _plr_pos_cooldown = 0;

	for (var _iy = 0; _iy < surface_height; _iy++) {
		for (var _ix = 0; _ix < surface_width; _ix++) {
		
			var _index = _iy * surface_width * 4 + _ix * 4;
			
			buffer_seek(buffer, buffer_seek_start, _index);
			var _pixel_main = buffer_read(buffer, buffer_u32) & 0xFFFFFF;
					
			_index = _iy * surface_width * 4 + (_ix - (_ix != 0)) * 4;
			buffer_seek(buffer, buffer_seek_start, _index);
			var _pixel_left = (_ix != 0) 
				? buffer_read(buffer, buffer_u32) & 0xFFFFFF
				: 0;
				
			_index = _iy * surface_width * 4 + (_ix + (_ix != surface_width - 1)) * 4;
			buffer_seek(buffer, buffer_seek_start, _index);
			var _pixel_right = (_ix != surface_width - 1) 
				? buffer_read(buffer, buffer_u32) & 0xFFFFFF
				: 0;
				
			if (_pixel_main != 0 && _pixel_left == 0) {
				draw_sprite_part(spr_ghz_tile, 1, 0, _iy % 16, 16, 1, _ix, _iy);
			}
			
			if (_pixel_main != 0 && _pixel_right == 0) {
				draw_sprite_part(spr_ghz_tile, 2, 0, _iy % 16, 16, 1, _ix - 15, _iy);
			}
		}
	}

	for (var _ix = 0; _ix < surface_width; _ix++)
	 {
		 for (var _iy = 0; _iy < surface_height; _iy++)
		 {
		
			var _index = _iy * surface_width * 4 + _ix * 4;
			
			buffer_seek(buffer, buffer_seek_start, _index);
			var _pixel_main = buffer_read(buffer, buffer_u32) & 0xFFFFFF;
			
			_index = (_iy - (_iy != 0)) * surface_width * 4 + _ix * 4;
			buffer_seek(buffer, buffer_seek_start, _index);
			var _pixel_top = (_iy != 0) 
				? buffer_read(buffer, buffer_u32) & 0xFFFFFF
				: 0;
				
			_index = (_iy + (_iy != surface_height - 1)) * surface_width * 4 + _ix * 4;
			buffer_seek(buffer, buffer_seek_start, _index);
			var _pixel_bot = (_iy != surface_height - 1) 
				? buffer_read(buffer, buffer_u32) & 0xFFFFFF
				: 0;
				
			if (_pixel_main != 0 && _pixel_bot == 0) {
				draw_sprite_part(spr_ghz_tile, 3, _ix % 16, 0, 1, 16, _ix, _iy-15);
			}
			
			if (_pixel_main != 0 && _pixel_top == 0) {
				draw_sprite_part(spr_ghz_grass_flat, 0, _ix % 16, 0, 1, 40, _ix, _iy-8);
				
				_plr_pos_cooldown--;
				
				if (_plr_pos_cooldown <= 0) {
					
	
					array_push(possible_plr_positions, [_ix + x, _iy + y]);
					
					_plr_pos_cooldown = 80;
				}
			}
		}
	}
	
	gpu_set_colorwriteenable(true, true, true, true);
	
	surface_reset_target();
	
	var _mgr = instance_exists(obj_player_mgr);
	
	if (_mgr) {
		instance_destroy(obj_player_mgr);
		_mgr = noone;
	}
	
	instance_create_depth(x, y, depth - 1, obj_player_mgr, { plr_pos_list: possible_plr_positions });
}

if keyboard_check_pressed(vk_space) {
	xx = irandom(2048);	
	yy = irandom(2048);	
}

if keyboard_check_pressed(ord("R")) {
	global.terrain_props.offset_x = xx;	
	global.terrain_props.offset_y = yy;	
	
	
	room_restart();
}

draw_set_color(c_blue);
draw_set_alpha(0.75);
draw_rectangle(0, water_level, room_width, room_height, false);
draw_set_alpha(1);
draw_set_color(c_white);
