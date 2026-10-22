extends "res://levels/level_base.gd"

@onready var level_exit_point_2: Marker2D = $Pausable/LevelExitRootNode/LevelExitPoint2

var speed = 25.0

var current_state: Callable = level_state_pass

func _ready() -> void:
	super._ready()
	GlobalsSignals.check_point_reached.connect(checkpoint_holder)

func _process(delta: float) -> void:
	current_state.call(delta)


func level_state_pass(_delta):
	pass

func level_state_1(delta):
	var direction = (level_exit_point_2.position - level_exit.position).normalized()
	level_exit.position += speed * delta * direction

func level_state_2(delta):
	var direction = (player.position + Vector2(0, -16) - level_exit.position).normalized()
	level_exit.position += speed * delta * direction
	speed += 0.1

func checkpoint_holder(number_of_checkpoint: int):
	match number_of_checkpoint:
		1: 
			current_state = level_state_1
			change_pause_state()
			show_dialog_menu()
			dialog_menu.start()
		2:
			change_pause_state()
			hide_dialog_menu()
			current_state = level_state_2
