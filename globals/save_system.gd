extends Node

const save_file_path = "res://save_file/save01.txt"

var number_of_levels = 5
var number_completed_levels = 0

var levels_data = {
	00 : [false, 8, 0, GlobalsScenes.id.LEVEL_00],
	01 : [false, 20, 0, GlobalsScenes.id.LEVEL_01],
	02 : [false, 0, 0, GlobalsScenes.id.LEVEL_02],
	03 : [false, 0, 0, GlobalsScenes.id.LEVEL_03],
	04 : [false, 1, 0, GlobalsScenes.id.LEVEL_04],
}


func _ready() -> void:
	read_save()


func check_available_level(level_number: int) -> bool:
	if level_number == 0:
		return true
	else:
		return levels_data[level_number - 1][0]

func get_number_completed_levels():
	return number_completed_levels

func get_level_id(level_number: int):
	return levels_data[level_number][3]

func get_number_of_collected_coins_in_level(level_number: int):
	return levels_data[level_number][2]

func get_number_of_coins_in_level(level_number: int):
	return levels_data[level_number][1]

func get_complete_state_of_level(level_number: int):
	return levels_data[level_number][0]

func level_complete(level_number: int, number_collected_coins: int):
	if not levels_data[level_number][0]:
		number_completed_levels += 1
	levels_data[level_number][0] = true
	if number_collected_coins > levels_data[level_number][2]:
		levels_data[level_number][2] = number_collected_coins
	write_save()

func reset_progress():
	number_completed_levels = 0
	for level_number in number_of_levels:
		levels_data[level_number][2] = 0
		levels_data[level_number][0] = false
	write_save()

func write_save():
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	save_file.store_line(str(number_completed_levels))
	for level_number in number_of_levels:
		save_file.store_line(str(levels_data[level_number][2]))
	save_file.close()

func read_save():
	if FileAccess.file_exists(save_file_path):
		var save_file = FileAccess.open(save_file_path, FileAccess.READ)
		number_completed_levels = int(save_file.get_line())
		for level_number in number_completed_levels:
			levels_data[level_number][2] = int(save_file.get_line())
			levels_data[level_number][0] = true
	else:
		var save_file = FileAccess.create_temp(FileAccess.READ, "save01", ".txt", true)
		save_file.close()
















#
