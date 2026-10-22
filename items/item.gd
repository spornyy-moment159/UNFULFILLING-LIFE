class_name Item extends Area2D

const types_textures_paths = {
	GlobalsParametes.items_types.COIN: "res://resourses/animated_texture/coin.tres",
	GlobalsParametes.items_types.SMALL_HP_FLASK: "res://resourses/animated_texture/small_hp_flask.tres",
	GlobalsParametes.items_types.BIG_HP_FLASK: "res://resourses/animated_texture/big_hp_flask.tres",
}

@export var type: GlobalsParametes.items_types = GlobalsParametes.items_types.COIN


func spawn(init_type: GlobalsParametes.items_types, new_position: Vector2):
	type = init_type
	$Sprite2D.texture = load(types_textures_paths[type])
	global_position = new_position

func _on_body_entered(_body: Node2D) -> void:
	GlobalsSignals.item_pickaped.emit(type)
	$AnimationPlayer.play("pickaped")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
