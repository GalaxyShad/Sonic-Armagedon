/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе

count--;

if count == 0 {
	obj_player_mgr.next_turn();
	instance_destroy();	
}

alarm[0] = 60;