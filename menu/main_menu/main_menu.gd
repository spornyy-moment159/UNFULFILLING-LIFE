extends CanvasLayer

func _ready() -> void:
	if not GlobalsParametes.is_intro_showed:
		GlobalsParametes.set_is_intro_showed(true)
		$AnimationPlayer.play("intro")
	set_scroll_offset_x(GlobalsParametes.get_scroll_offset_background())
	if SaveSystem.get_number_completed_levels() == 5:
		$Control/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonEndScreen.show()
		var buffer = 0
		for i in 5:
			buffer += SaveSystem.get_number_of_collected_coins_in_level(i)
		
		if buffer == 29:
			$Control/MarginContainer/BonusButton.show()

func set_scroll_offset_x(value):
	$BackgroundForest.set_scroll_offset_x(value)


func _on_button_level_select_pressed() -> void:
	GlobalsParametes.set_scroll_offset_background($BackgroundForest.get_scroll_offset_x())
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.LEVEL_CHOICE_MENU)

func _on_button_description_pressed() -> void:
	GlobalsParametes.set_scroll_offset_background($BackgroundForest.get_scroll_offset_x())
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.DESCRIPTION_SCREEN)

func _on_button_exit_pressed() -> void:
	GlobalsSignals.exit_game_button_pressed.emit()

func _on_button_end_screen_pressed() -> void:
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.END_SCREEN)

func _on_bonus_button_pressed() -> void:
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.BONUS_SCREEN)
