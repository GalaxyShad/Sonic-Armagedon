/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе


x = lerp(x, target_x, 0.05);
y = lerp(y, target_y, 0.05);

mx = mouse_x;
my = mouse_y;

if (display_mouse_get_x() != mx_prev || 
	display_mouse_get_y() != my_prev) {
	is_target_player = false;	
}

if (!is_target_player) && (mx < x - 64 || mx > x + 64 || my < y - 64 || my > y + 64) {
	target_x = mx;
	target_y = my;
}

mx_prev = display_mouse_get_x();
my_prev = display_mouse_get_y();