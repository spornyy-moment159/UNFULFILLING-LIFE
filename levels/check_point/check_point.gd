extends Area2D

@export var number_of_check_point: int = 1


func _on_body_entered(body: Node2D) -> void:
	GlobalsSignals.check_point_reached.emit(number_of_check_point)
	queue_free()
