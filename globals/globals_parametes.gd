extends Node

enum items_types{ COIN, SMALL_HP_FLASK, BIG_HP_FLASK}

var scroll_offset_background = 0
var is_intro_showed = false
var player_position: Vector2
var path_follow_for_flying_eye: Array[PathFollow2D] = []
var orb_root: Node

func set_path_follow_for_flying_eye(new_value):
	path_follow_for_flying_eye.append(new_value) 

func get_random_path_follow_for_flying_eye():
	return path_follow_for_flying_eye.pick_random()

func set_orb_root(new_value):
	orb_root = new_value

func get_orb_root():
	return orb_root

func get_player_position():
	return player_position

func set_player_position(position):
	player_position = position

func set_scroll_offset_background(value: float):
	scroll_offset_background = value

func get_scroll_offset_background() -> float:
	return scroll_offset_background

func set_is_intro_showed(value: bool):
	is_intro_showed = value

func get_is_intro_showed() -> bool:
	return is_intro_showed
