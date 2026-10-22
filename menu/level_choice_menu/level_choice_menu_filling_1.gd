extends MarginContainer


func _on_button_pressed() -> void:
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.LEVEL_00)
