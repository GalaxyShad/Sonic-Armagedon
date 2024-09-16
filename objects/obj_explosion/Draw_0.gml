/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе



var _scale = radius / 100;

draw_sprite_ext(sprite_index, image_index, x, y, _scale, _scale, 0, c_white, 1);

var _trn = obj_terrain;

surface_set_target(_trn.trn_surface);

draw_set_color(c_black);
//draw_circle(x - _trn.x, y - _trn.y, radius, false);
draw_set_color(c_white);
draw_sprite_ext(sprite_index, image_index, x - _trn.x, y - _trn.y, _scale, _scale, 0, c_black, 1);
surface_reset_target();