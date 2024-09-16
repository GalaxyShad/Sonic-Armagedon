/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе

image_angle = angle;

draw_self();

state_machine.draw();

draw_set_color(TEAM_COLOR_LIST[team_id]);
draw_set_halign(fa_center);
draw_text(x, y-64, "MEMBER #" + string(member_id + 1));
draw_text(x, y-48, angle);
draw_set_halign(fa_left);
draw_set_color(c_white);
