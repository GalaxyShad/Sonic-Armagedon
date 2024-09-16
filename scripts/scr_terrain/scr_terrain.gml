
function is_terrain_solid(_x, _y) {
	var _inst_terrain = obj_terrain;//instance_find(obj_terrain, 0);
	
	_x = floor(_x) - _inst_terrain.x;
	_y = floor(_y) - _inst_terrain.y;
	
	if (_inst_terrain == noone) 
		return false;
		
	if (_x < 0 || _y < 0 || _x >= _inst_terrain.surface_width || _y >= _inst_terrain.surface_height) 
		return false;
	
	var _index = (_y * _inst_terrain.surface_width + _x) * 4;
	var _buf = _inst_terrain.trn_surface_buffer;
			
	buffer_seek(_buf, buffer_seek_start, _index);
	
	var _px = buffer_read(_buf, buffer_u32) & 0xFFFFFF;
	
	return _px != 0;
}