extends EnemyBase

const ORB = preload("uid://d6o7gvcr5cgs")

@onready var attack_timer: Timer = $AttackTimer

var path_follow: PathFollow2D
var orb_root: Node2D

var path_follow_speed = 50
var speed = 1500
var target_movement_position: Vector2


func _physics_process(delta: float) -> void:
	player_position = GlobalsParametes.get_player_position()
	if not is_dead:
		check_flip_on_x_axis()
	else :
		velocity.y += gravity * delta
	if current_state == states_parameters[states.MOVE][0]:
		call(current_state, delta)
	else:
		call(current_state)
	
	move_and_slide()

func _ready() -> void:
	super._ready()
	change_state(states.WAIT)


func start():
	orb_root = GlobalsParametes.get_orb_root()
	path_follow = GlobalsParametes.get_random_path_follow_for_flying_eye()
	change_state(states.MOVE)
	update_target_movement_position()

func set_path_follow(new_path_follow: PathFollow2D):
	path_follow = new_path_follow

func update_target_movement_position():
	path_follow.progress += path_follow_speed
	target_movement_position = path_follow.position

func state_move(delta):
	velocity = (target_movement_position - position).normalized() * delta * speed
	if (target_movement_position - position).length() < 5:
		update_target_movement_position()

func state_dead():
	velocity.x =  0
	attack_timer.stop()

func state_hit():
	attack_timer.start(5)

func spawn_orb():
	var orb: Orb = ORB.instantiate()
	orb.start((player_position + Vector2(0, -16) - attack_mark.global_position).normalized(), attack_mark.global_position, damage)
	orb_root.add_child(orb)


func _on_attack_timer_timeout() -> void:
	change_state(states.ATTACK)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["hit", "attack"]:
		change_state(states.MOVE)
	if anim_name == "dead":
		animation_player.play("disappear")
