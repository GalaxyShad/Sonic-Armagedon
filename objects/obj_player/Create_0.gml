
gnd = false;

xsp = 0;
ysp = 0;
gsp = 0;

hp = 100;

team_id = 0;
member_id = 0;

TEAM_COLOR_LIST = [c_red, c_blue, c_orange, c_green, c_purple, c_aqua];

is_my_turn = false;


acceleration_speed		=	0.046875;
deceleration_speed		 =	0.5;
friction_speed			=	0.046875;
top_speed				=	6;
gravity_force			=   0.21875;
air_acceleration_speed	=	0.09375;
jump_force				=	6.5;

enum STATE {
	NORMAL,
	HURT,
	JUMP
}

state_machine = new StateMachineBuilder(self)
	.add(new PlayerNormalState(self))
	.add(new PlayerHurtState(self))
	.add(new PlayerJumpState(self))
	.build();


angle = 0;

#macro X 0
#macro Y 1

wall_radius = 10;
floor_radius = 9;


calculate_angle = function () {
	var _sin = dsin(angle);
	var _cos = dcos(angle);
	
	var _p1 = [x - 9 * _cos, y - 9 * -_sin];
	var _p2 = [x + 9 * _cos, y + 9 * -_sin];
	
	var _p1_found = false;
	var _p2_found = false;
	
	
	for (var i = 0; i < 36; i++) {
		if (!is_terrain_solid(_p1[X], _p1[Y])) {
			if (!_p1_found) {
				_p1[X]+=_sin;
				_p1[Y]+=_cos;
			}
		} else {
			_p1_found = true;	
		}
		
		if (!is_terrain_solid(_p2[X], _p2[Y])) {
			if (!_p2_found) {
				_p2[X]+=_sin;
				_p2[Y]+=_cos;
			}
		} else {
			_p2_found = true;	
		}
	}
	
	return (_p1_found && _p2_found) 
		? point_direction(_p1[X], _p1[Y], _p2[X], _p2[Y]) 
		: angle;
}



calculate_landing_gsp = function (_angle) {
	var _in_range = function(_v, _a, _b) { return (_v >= _a && _v <= _b); }
	
	if (_in_range(_angle, 0, 23) || _in_range(_angle, 339, 360) || (abs(xsp) > abs(ysp))) {
		return xsp;
	}
	
	var _factor = (_in_range(_angle, 0, 45) || _in_range(_angle, 316, 360)) 
		? 0.5
		: 1;
	
	return ysp * _factor  * -sign(dsin(_angle));	
}

is_collision_right = function(_angle) {
	return is_terrain_solid(x + 10 * dcos(_angle), y + 10 * -dsin(_angle))
}

is_collision_left = function(_angle) {
	return is_terrain_solid(x - 10 * dcos(_angle), y - 10 * -dsin(_angle))
}

is_collision_top = function(_angle) {
	return is_terrain_solid(x - 20 * dsin(_angle), y - 20 * dcos(_angle))
}

is_collision_bottom = function(_angle, _ext = 0) {
	return is_terrain_solid(x + (20 + _ext) * dsin(_angle), y + (20 + _ext) * dcos(_angle))
}

is_collision_slope = function(_angle) {
	var _sin = dsin(_angle);
	var _cos = dcos(_angle);
	
	var _x = x + 20 * _sin;
	var _y = y + 20 * _cos;
	
	for (var i = 0; i < 16; i++) {
		_x += _sin;
		_y += _cos;
		
		if (is_terrain_solid(_x, _y)) return true;
	}
	
	return false;
}