extends CanvasLayer


func _on_video_stream_player_finished() -> void:
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.MAIN_MENU)
