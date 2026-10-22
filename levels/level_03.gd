extends "res://levels/level_base.gd"

@onready var level_exit_point_2: Marker2D = $Pausable/LevelExitRootNode/LevelExitPoint2
@onready var place_holder_mark_1: Marker2D = $Pausable/CheckPointsRootNode/PlaceHolderMark1
@onready var animation_player: AnimationPlayer = $Pausable/CheckPointsRootNode/AnimationPlayer

var speed = 50

var current_state: Callable = pass_func

func _ready() -> void:
	super._ready()
	GlobalsSignals.check_point_reached.connect(checkpoint_holder)

func _process(delta: float) -> void:
	current_state.call(delta)
	print(get_tree().paused)

func pass_func(_delta):
	pass

func state_1(delta):
	var direction = (level_exit_point_2.position - level_exit.position).normalized()
	if direction == Vector2.ZERO:
		current_state = pass_func
	level_exit.position += speed * delta * direction

func checkpoint_holder(number_of_checkpoint: int):
	match number_of_checkpoint:
		1: 
			change_pause_state()
			show_dialog_menu()
			dialog_menu.start()
		2:
			change_pause_state()
			hide_dialog_menu()
			current_state = state_1
			place_destroyed_structure()
			animation_player.play("show_advice")

func place_destroyed_structure():
	var pattern = world.tile_set.get_pattern(1) 
	var coord: Vector2 = world.local_to_map(place_holder_mark_1.position)
	world.set_pattern(0, Vector2i(coord), pattern)






#
