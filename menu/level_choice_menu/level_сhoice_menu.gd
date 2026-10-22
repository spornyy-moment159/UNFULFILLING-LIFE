extends CanvasLayer

@onready var root_node_for_filling: Control = $Control/VBoxContainer/RootNodeForFilling

const LEVEL_CHOICE_MENU_FILLING_2 = preload("uid://d1q3nf1t2u0lr")
const LEVEL_CHOICE_MENU_FILLING_1 = preload("uid://lskklq7w5n1e")

func _ready() -> void:
	if SaveSystem.number_completed_levels == 0:
		root_node_for_filling.add_child(LEVEL_CHOICE_MENU_FILLING_1.instantiate())
		$Control/VBoxContainer/MarginContainer/ResetProgressButton.hide()
	else:
		root_node_for_filling.add_child(LEVEL_CHOICE_MENU_FILLING_2.instantiate())
	set_scroll_offset_x(GlobalsParametes.get_scroll_offset_background())


func set_scroll_offset_x(value):
	$BackgroundForest.set_scroll_offset_x(value)


func _on_back_button_pressed() -> void:
	GlobalsParametes.set_scroll_offset_background($BackgroundForest.get_scroll_offset_x())
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.MAIN_MENU)

func _on_reset_progress_button_pressed() -> void:
	GlobalsParametes.set_scroll_offset_background($BackgroundForest.get_scroll_offset_x())
	SaveSystem.reset_progress()
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.LEVEL_CHOICE_MENU)
