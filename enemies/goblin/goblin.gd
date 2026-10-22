extends "res://enemies/enemy_grounded_base.gd"

func _ready() -> void:
	super._ready()
	prefix = "goblin/"
	update_anim_names(prefix)
	change_state(states.MOVE)
