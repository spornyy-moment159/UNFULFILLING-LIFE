extends Area2D

@export var checkpoint_number: int = 1


func _on_body_entered(_body: Node2D) -> void:
	GlobalsSignals.check_point_reached.emit(checkpoint_number)
	$CollisionShape2D.queue_free()
