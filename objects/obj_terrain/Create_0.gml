// Создание поверхности
surface_width = global.terrain_props.width;
surface_height = global.terrain_props.height;

global.terrain_props.surface = surface_create(surface_width, surface_height);

surface_id = global.terrain_props.surface;
shader_id = sh_simplex_noise;


scale = 3.5;
tilt = 0;
sharp = 1;
th = 0.5;

buffer = -1;

trn_surface = -1;
trn_surface_buffer = buffer_create(surface_width * surface_height * 4, buffer_fixed, 1);


xx = global.terrain_props.offset_x;
yy = global.terrain_props.offset_y;

water_height = 64;
water_level = room_height - water_height;

depth = 10;

x = room_width / 2 - surface_width / 2;
y = room_height - surface_height - water_height / 2;

possible_plr_positions = [];