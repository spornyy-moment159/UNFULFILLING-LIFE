extends Node

enum id{
	MAIN_MENU,
	LEVEL_CHOICE_MENU,
	DESCRIPTION_SCREEN,
	LEVEL_00,
	LEVEL_01,
	LEVEL_02,
	LEVEL_03,
	LEVEL_04,
	END_SCREEN,
	BONUS_SCREEN,
}

const scenes_dictionary: Dictionary = {
	id.MAIN_MENU: ["res://menu/main_menu/main_menu.tscn"],
	id.LEVEL_CHOICE_MENU: ["res://menu/level_choice_menu/level_сhoice_menu.tscn"],
	id.DESCRIPTION_SCREEN: ["res://description/description_screen.tscn"],
	id.END_SCREEN: ["res://end_screen/end_screen.tscn"],
	id.BONUS_SCREEN: ["res://bonus_screen/bonus_screen.tscn"],
	id.LEVEL_00:["res://levels/level_00.tscn", "res://resourses/text_files/level_00/level_00_title.txt", "res://resourses/text_files/level_00/level_00_description.txt", "res://resourses/text_files/level_00/level_00_texture.png"],
	id.LEVEL_01:["res://levels/level_01.tscn", "res://resourses/text_files/level_01/level_01_title.txt", "res://resourses/text_files/level_01/level_01_description.txt", "res://resourses/text_files/level_01/level_01_texture.png"],
	id.LEVEL_02:["res://levels/level_02.tscn", "res://resourses/text_files/level_02/level_02_title.txt", "res://resourses/text_files/level_02/level_02_description.txt", "res://resourses/text_files/level_02/level_02_texture.png"],
	id.LEVEL_03:["res://levels/level_03.tscn", "res://resourses/text_files/level_03/level_03_title.txt", "res://resourses/text_files/level_03/level_03_description.txt", "res://resourses/text_files/level_03/level_03_texture.jpg"],
	id.LEVEL_04:["res://levels/level_04.tscn", "res://resourses/text_files/level_04/level_04_title.txt", "res://resourses/text_files/level_04/level_04_description.txt", "res://resourses/text_files/level_04/level_04_texture.jpg"],
}

func get_scene_path(_id: id) -> NodePath:
	return scenes_dictionary[_id][0]

func get_level_title_file_path(_id):
	return scenes_dictionary[_id][1]

func get_level_description_file_path(_id):
	return scenes_dictionary[_id][2]

func get_level_title_texture_file_path(_id):
	return scenes_dictionary[_id][3]
