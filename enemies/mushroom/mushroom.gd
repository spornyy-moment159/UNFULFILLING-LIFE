extends "res://enemies/enemy_grounded_base.gd"

func _ready() -> void:
	super._ready()
	change_state(states.MOVE)
