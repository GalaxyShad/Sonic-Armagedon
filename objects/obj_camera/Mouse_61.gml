/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе

var _w = camera_get_view_width(view_camera[0]) + 16;
var _h = camera_get_view_height(view_camera[0]) + 9;

_w = min(_w, max_view_width);
_h = min(_h, max_view_height);

camera_set_view_size(view_camera[0], _w, _h)