extends Node

signal change_scene_button_pressed(new_scene: GlobalsScenes.id)
signal exit_game_button_pressed()

signal player_hp_changed(value: int)
signal player_died()
signal item_pickaped(type: GlobalsParametes.items_types)
signal level_exit_reached()
signal check_point_reached(number: int)
