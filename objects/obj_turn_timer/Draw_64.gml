/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе

draw_set_color(c_black);
draw_rectangle(16-4, 600-16, 16+32, 600+16, false);
draw_set_color(c_white);

draw_set_valign(fa_middle);
draw_text(16, 600, count);
draw_set_valign(fa_top);