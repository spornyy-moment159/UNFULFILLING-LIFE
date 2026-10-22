extends CanvasLayer

func _ready() -> void:
	$Control/VBoxContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/RichTextLabel.text = FileAccess.open("res://resourses/text_files/game_description.txt", FileAccess.READ).get_as_text()
	set_scroll_offset_x(GlobalsParametes.get_scroll_offset_background())


func set_scroll_offset_x(value):
	$BackgroundForest.set_scroll_offset_x(value)


func _on_back_button_pressed() -> void:
	GlobalsParametes.set_scroll_offset_background($BackgroundForest.get_scroll_offset_x())
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.MAIN_MENU)


func _on_check_button_toggled(toggled_on: bool) -> void:
	$AnimationPlayer.active = toggled_on
	print($AnimationPlayer.active)
