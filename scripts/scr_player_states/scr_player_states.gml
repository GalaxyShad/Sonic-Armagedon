
function StateMachineBuilder(_inst) constructor
{
	state_list = [];
	
	static add = function(_state) {
		array_push(state_list, _state)
		return self;
	}
	
	static build = function() {
		return new StateMachine(state_list);	
	}
}

function StateMachine(_state_list) constructor 
{
	m_state_list = _state_list;
	m_cur_state_id = 0;
	m_cur_state = m_state_list[m_cur_state_id];
	m_cur_state.on_begin();
	
	static change_to = function(_state_id) {
		m_cur_state.on_exit();
		
		m_cur_state_id = _state_id;
		m_cur_state = m_state_list[m_cur_state_id];
		
		m_cur_state.on_begin();
	}
	
	static get_id = function () { return m_cur_state_id; }
	
	static step = function () { m_cur_state.on_step(); }
	
	static end_step = function() { m_cur_state.on_animate(); }
	
	static draw = function() { m_cur_state.on_draw(); }
	
	static landing = function(_ground_y) { m_cur_state.on_landing(_ground_y); }
}

function StateBase() constructor
{
    static on_begin = function() {}
	
	static on_exit = function() {}
	
	static on_landing = function(_ground_y) {}
	
	static on_step = function() {}
	
	static on_animate = function() {}
	
	static on_draw = function() {}
}

function PlayerNormalState(_plr) : StateBase() constructor
{
	plr = _plr;
	
    static on_animate = function() { with (plr) {
		if (gnd) {
			if (gsp == 0) sprite_index = spr_sonic_idle;	
			if (abs(gsp) > 0) sprite_index = spr_sonic_walk;	
			if (abs(gsp) >= 6) sprite_index = spr_sonic_run;	
			
			image_speed = abs(gsp) / 4 + 0.25;
			
			if (gsp != 0)
				image_xscale = sign(gsp);
		} else {
			
		}
	}}
}

function PlayerJumpState(_plr) : StateBase() constructor
{
	plr = _plr;
	
	static on_step = function() {
		if (plr.ysp < -4 && !keyboard_check(vk_up)) 
			plr.ysp = -4;
	}
	
	static on_landing = function() {
		plr.state_machine.change_to(STATE.NORMAL);
	}
	
    static on_animate = function() { with (plr) {
		image_speed = abs(gsp) / 8 + 1;
		sprite_index = spr_sonic_roll;
		
		if (keyboard_check(vk_right)) image_xscale = 1;
		if (keyboard_check(vk_left)) image_xscale = -1;
	}}
}

function PlayerHurtState(_plr) : StateBase() constructor {
	plr = _plr;
	frames_count = sprite_get_number(spr_sonic_hurt);
	
	static on_begin = function() { with (plr) {
		image_index = 0;
	}}
	
    static on_animate = function() {
		plr.image_speed = 0.5;
		plr.sprite_index = spr_sonic_hurt;
		
		if (plr.image_index >= frames_count - 1)
			plr.image_index = frames_count - 1;
			
		
	}
	
	static on_draw = function() {
		plr.angle = point_direction(plr.x, plr.y, plr.xprevious, plr.yprevious);
	}
}