extends Node

@onready var current_scene_root: Node = $CurrentSceneRoot

@export var start_scene: GlobalsScenes.id
var current_scene: GlobalsScenes.id

func _ready() -> void:
	GlobalsSignals.change_scene_button_pressed.connect(change_scene)
	GlobalsSignals.exit_game_button_pressed.connect(exit_game)
	change_scene(start_scene)


func change_scene(new_scene: GlobalsScenes.id):
	if get_tree().paused:
		get_tree().paused = false
	
	for scene in current_scene_root.get_children():
		scene.queue_free()
	
	if not new_scene in [GlobalsScenes.id.MAIN_MENU, GlobalsScenes.id.LEVEL_CHOICE_MENU]:
		GlobalsParametes.set_scroll_offset_background(0)
	
	current_scene = new_scene
	current_scene_root.add_child(load(GlobalsScenes.get_scene_path(current_scene)).instantiate())

func exit_game():
	get_tree().quit()












#
