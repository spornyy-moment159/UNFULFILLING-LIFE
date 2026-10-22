extends CanvasLayer

@onready var grid_container: GridContainer = $Control/VBoxContainer/MarginContainer2/ScrollContainer/GridContainer

func _on_back_button_pressed() -> void:
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.MAIN_MENU)

func _ready() -> void:
	for i in 139:
		var buffer = TextureRect.new()
		buffer.custom_minimum_size = Vector2(350, 350)
		buffer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		buffer.texture = load("res://assets/mems/" + str(i + 1) + ".jpg")
		grid_container.add_child(buffer)
