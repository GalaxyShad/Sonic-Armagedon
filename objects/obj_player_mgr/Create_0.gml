/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе

cur_team = 0;

cur_member_a = 0;
cur_member_b = 0;

team_a = [];
team_b = [];

var _plr_pos_arr = array_shuffle(plr_pos_list);

for (var i = 0; i < 5; i++) {
	var _plr = instance_create_depth(_plr_pos_arr[i][0], _plr_pos_arr[i][1], depth, obj_player);	
	
	array_push(team_a, _plr);
	
	_plr.team_id = 0;
	_plr.member_id = i;
}

for (var i = 0; i < 5; i++) {
	var _plr = instance_create_depth(_plr_pos_arr[i+5][0], _plr_pos_arr[i+5][1], depth, obj_player);	
	
	array_push(team_b, _plr);
	
	_plr.team_id = 1;
	_plr.member_id = i;
}

cur_player = team_a[0];

next_turn = function() {
	cur_team++;
	cur_team %= 2;	
	
	if (cur_team == 0) { 
		cur_member_a++;
		cur_member_a %= 5;
		
		while (!instance_exists(team_a[cur_member_a])) {
			cur_member_a++;
			cur_member_a %= 5;
		}
		
		cur_player = team_a[cur_member_a];
	}
	
	if (cur_team == 1) {
		cur_member_b++;
		cur_member_b %= 5;
		
		while (!instance_exists(team_b[cur_member_b])) {
			cur_member_b++;
			cur_member_b %= 5;
		}
		
		cur_player = team_b[cur_member_b];
	}
	
	instance_create_depth(x, y, -1000, obj_turn_timer);
}
