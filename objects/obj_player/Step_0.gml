is_my_turn = id == obj_player_mgr.cur_player;

if (is_my_turn && obj_camera.is_target_player) {
	obj_camera.target_x = x;
	obj_camera.target_y = y;
}

if (gnd) {
	
	if (gsp != 0)
		gsp -= 0.125 * dsin(angle);
	
	xsp = gsp * dcos(angle);
	ysp = gsp * -dsin(angle);
}

x += xsp;
y += ysp;

if (!gnd) {
	ysp += gravity_force;
	
	if (ysp >= 10 && state_machine.get_id() != STATE.HURT)
		state_machine.change_to(STATE.HURT);
	
	if (ysp >= 16) ysp = 16;
} 

if (y-20 > room_height && is_my_turn) {
	instance_destroy();	
	obj_player_mgr.next_turn();
}


if ((!gnd) && (is_terrain_solid(x, y+20))) {
	gnd = true;
	
	angle = 0;
	angle = calculate_angle();
	
	if (state_machine.get_id() == STATE.HURT && abs(point_distance(x, y, xprevious, yprevious)) < 1 ) {
		state_machine.change_to(STATE.NORMAL);
	}
	
	gsp = calculate_landing_gsp(angle);
	
	state_machine.landing(y+20);
}

if (!gnd && is_collision_top(0)) {
	if (ysp < 0) ysp = 0;

	while (is_collision_top(0)) y++;
}

var _sin = dsin(angle);
var _cos = dcos(angle);

if (is_collision_right(angle)) {
	xsp = 0;
	
	if (gnd) gsp = 0;
	
	while (is_collision_right(angle)) {
		x -= _cos;
		y -= -_sin;
	}
}

if (is_collision_left(angle)) {
	xsp = 0;
	
	if (gnd) gsp = 0;
	
	while (is_collision_left(angle)) {
		x += _cos;
		y += -_sin;
	}
}


if (gnd) {

	while (!is_collision_bottom(angle) && is_collision_slope(angle)) {
		y += _cos;
		x += _sin;
	}
	
	while (is_collision_bottom(angle)) {
		y -= _cos;
		x -= _sin;
	}

		
	if (!is_collision_slope(angle))
		gnd = false;
		
	angle = calculate_angle();
	
	if (angle >= 46 && angle <= 315 && abs(gsp) <= 2.5) {
		gnd = false;
		state_machine.change_to(STATE.HURT);
	}
}



if (is_my_turn && state_machine.get_id() != STATE.HURT) {
	
	if (gnd) {
		if (keyboard_check(vk_left)) {
		    if (gsp > 0) {
		        gsp -= deceleration_speed;  //decelerate
		        if (gsp <= 0) gsp = -0.5;  //emulate deceleration quirk
		    } else if (gsp > -top_speed) {
		        gsp -= acceleration_speed;  //accelerate
		        if (gsp <= -top_speed) gsp = -top_speed; //impose top speed limit
		    }
		
			obj_camera.is_target_player = true;
		}

		else if (keyboard_check(vk_right)) {
		    if (gsp < 0) {
		        gsp += deceleration_speed; //decelerate
		        if (gsp >= 0) gsp = 0.5; //emulate deceleration quirk
		    } else if (gsp < top_speed) {
		        gsp += acceleration_speed; //accelerate
		        if (gsp >= top_speed)
		            gsp = top_speed; //impose top speed limit
		    }
		
			obj_camera.is_target_player = true;
		
		}
		else
			gsp -= min(abs(gsp), friction_speed) * sign(gsp); //decelerate
	} else {
		if (keyboard_check(vk_left)) {
			xsp -= air_acceleration_speed;
			xsp = max(xsp, -top_speed);
		}
		else if (keyboard_check(vk_right)) {
			xsp += air_acceleration_speed;
			xsp = min(xsp, top_speed);
		}
	}

	if (keyboard_check_pressed(vk_up) && gnd) {
		gnd = false;
		
		xsp -= jump_force * dsin(angle);
		ysp -= jump_force * dcos(angle);
		
		state_machine.change_to(STATE.JUMP);
	}
	
	if (keyboard_check_pressed(vk_space))
		instance_create_depth(x, y+15, depth, obj_dynamyte);
} else if (gnd) {
	gsp -= min(abs(gsp), friction_speed) * sign(gsp); //decelerate
}

var _explosion = instance_nearest(x, y, obj_explosion);
if (_explosion != noone) {
	var _dist = distance_to_point(_explosion.x, _explosion.y);
	var _radius = _explosion.radius * 1.25;
	
	if (_dist <= _radius && _explosion.image_index == 4) {
		state_machine.change_to(STATE.HURT);
		
		var _ang = point_direction(_explosion.x, _explosion.y, x, y);
		
		var _spd = (_radius - _dist) / 7;
		
		xsp = _spd * dcos(_ang);
		ysp = _spd * -dsin(_ang);
		
		var _dmg = (_radius - _dist) * (_explosion.dmg / _radius);
		
		hp -= floor(_dmg);
		
		gnd = false;
	}
}



if (!gnd) {
	if (ysp < 0 && ysp > -4)
		xsp -= (((xsp * 1_000) div 125) / 256_000);
}

state_machine.step();