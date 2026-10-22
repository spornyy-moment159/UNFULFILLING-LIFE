extends CanvasLayer

func _ready() -> void:
	$Control/VBoxContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/RichTextLabel.text = FileAccess.open("res://resourses/text_files/end_words.txt", FileAccess.READ).get_as_text()


func _on_back_button_pressed() -> void:
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.MAIN_MENU)
