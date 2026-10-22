extends EnemyBase

var speed = 5000

var prefix: String 

var player_is_near = false

func _physics_process(delta: float) -> void:
	player_position = GlobalsParametes.get_player_position()
	velocity.y += gravity * delta
	
	if not is_dead:
		check_flip_on_x_axis()
	
	if current_state == states_parameters[states.MOVE][0]:
		call(current_state, delta)
	else:
		call(current_state)
	
	move_and_slide()

func state_attack():
	velocity.x = 0

func state_move(delta):
	var direction = (player_position - position).normalized().x
	if not player_is_near:
		velocity.x = direction * speed * delta

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(damage)

func _on_attack_range_body_entered(_body: Node2D) -> void:
	change_state(states.ATTACK)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in [get_anim_name(states.HIT), get_anim_name(states.ATTACK)]:
		change_state(states.MOVE)
	if anim_name == get_anim_name(states.DEAD):
		animation_player.play(prefix + "disappear")


func _on_movement_termonator_area_body_entered(body: Node2D) -> void:
	player_is_near =  true


func _on_movement_termonator_area_body_exited(body: Node2D) -> void:
	player_is_near = false
