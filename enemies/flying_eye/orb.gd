class_name Orb extends Area2D

var damage = 1
var speed = 60
var direction: Vector2 

func _process(delta: float) -> void:
	transform.origin += delta * direction * speed

func start(target_direction, init_position, init_damage):
	direction = target_direction
	global_position = init_position
	damage = init_damage

func hit(_value):
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(damage)
	queue_free()
