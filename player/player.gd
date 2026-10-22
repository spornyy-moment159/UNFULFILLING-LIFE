class_name Player extends CharacterBody2D

signal died()
#adasd
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var climb_timer: Timer = $ClimbTimer
@onready var attack_collision_root: Node2D = $AttackCollisionRoot
@onready var block_timer: Timer = $BlockTimer
@onready var block_reload_timer: Timer = $BlockTimer/BlockReloadTimer

enum states{
	IDLE,
	WALK,
	RUN,
	ATTACK_1,
	ATTACK_2,
	HIT,
	SIT,
	BLOCK,
	DEAD,
	JUMP,
	CLIMB,
}

const states_parameters = {
	states.IDLE: ["get_input_idle", "idle"],
	states.WALK: ["get_input_walk", "walk"],
	states.RUN: ["get_input_run", "run"],
	states.ATTACK_1: ["get_input_attack", "attack_1"],
	states.ATTACK_2: ["get_input_attack", "attack_2"],
	states.HIT: ["get_input_hit", "hit"],
	states.SIT: ["get_input_sit", "sit"],
	states.BLOCK: ["get_input_block", "block"],
	states.DEAD: ["get_input_dead", "death"],
	states.JUMP: ["get_input_jump", "jump_up"],
	states.CLIMB: ["get_input_climb", "climb"],
}

var current_state: states = states.IDLE
var current_input_function: String = states_parameters[states.IDLE][0]

var gravity = 500
var normal_speed = 100
var increased_speed = 200
var decreased_speed = 50
var current_speed = 100
var jump_speed = 250
var damage = 5

var is_on_lader = [false, false]
var movement_push = Vector2.ZERO

var max_hp = 5
var current_hp = 3:
	set(value):
		current_hp = min(value, max_hp)
		GlobalsSignals.player_hp_changed.emit(current_hp)
		if current_hp <= 0:
			GlobalsSignals.player_died.emit()
			change_state(states.DEAD)

var is_blocking = false
var block_is_reloading = false

func _ready() -> void:
	GlobalsSignals.item_pickaped.connect(item_pickup)

func _physics_process(delta: float) -> void:
	if current_state != states.CLIMB:
		velocity.y += gravity * delta
	call(current_input_function)
	
	add_movement_push()
	
	move_and_slide()
	
	collision_calc()
	
	GlobalsParametes.set_player_position(global_position)


func deactivate_camera():
	$Camera2D.enabled = false

func reset():
	current_hp = max_hp
	change_state(states.IDLE)
	show()

func item_pickup(type: GlobalsParametes.items_types):
	match type:
		GlobalsParametes.items_types.SMALL_HP_FLASK: heal(1)
		GlobalsParametes.items_types.BIG_HP_FLASK: heal(2)

func heal(value):
	current_hp += value

func add_movement_push():
	velocity += movement_push
	movement_push = Vector2.ZERO

func collision_calc():
	for collision_number in get_slide_collision_count():
		var collision = get_slide_collision(collision_number)
		if collision.get_collider().is_in_group("enemies"):
			hit_by_touch(1, collision.get_position())

func hit_by_touch(hit_damage, position_of_hit):
	if (not current_state in [states.HIT, states.DEAD]) and (not is_blocking):
		change_state(states.HIT)
		current_hp -= hit_damage
		movement_push.y -= 200
		movement_push.x += sign(global_position.x - position_of_hit.x) * 600

func hit(hit_damage):
	if (not current_state in [states.HIT, states.DEAD]) and (not is_blocking):
		change_state(states.HIT)
		current_hp -= hit_damage

func change_state(new_state: states):
	if current_state == states.BLOCK:
		is_blocking = false
		block_timer.stop()
	if current_state == states.CLIMB:
		animation_player.active = true
		animation_player.speed_scale = 1
	
	if new_state == states.BLOCK and block_is_reloading:
		current_state = states.IDLE
	else:
		current_state = new_state
	current_input_function = states_parameters[current_state][0]
	animation_player.play(states_parameters[current_state][1])
	
	match current_state:
		states.IDLE: 
			pass
		states.WALK: 
			current_speed = normal_speed
		states.JUMP: 
			pass
		states.RUN:
			current_speed = increased_speed
		states.DEAD:
			velocity = Vector2.ZERO
			died.emit()
		states.BLOCK:
			is_blocking = true
			block_timer.start()
			velocity.x = 0
		states.SIT:
			velocity.x = 0
		states.ATTACK_1:
			current_speed = decreased_speed
			velocity.x = 0
		states.ATTACK_2:
			current_speed = decreased_speed
			velocity.x = 0
		states.HIT:
			current_speed = decreased_speed
			velocity.x = 0
		states.CLIMB:
			velocity.x = 0

func get_input_climb():
	get_input_climb_vertical_movement()
	if velocity.y == 0:
		animation_player.active = false
	if velocity.y > 0:
		animation_player.active = true
		animation_player.speed_scale = -1
	if velocity.y < 0:
		animation_player.active = true
		animation_player.speed_scale = 1
	
	if not is_on_lader[0] and not is_on_lader[1] and climb_timer.is_stopped():
		climb_timer.start()
	
	if Input.is_action_just_pressed("jump"):
		get_input_horizontal_movement()
		get_input_jump_movement()
		change_state(states.JUMP)

func get_input_hit():
	get_input_horizontal_movement()

func get_input_attack():
	get_input_horizontal_movement()
	get_input_jump_movement()

func get_input_sit():
	check_flip_on_x_axis()
	
	if not Input.is_action_pressed("sit_down"):
		change_state(states.IDLE)
	
	if check_is_on_lader():
		change_state(states.CLIMB)
	
	if Input.is_action_just_pressed("attack_1"):
		change_state(states.ATTACK_1)
	
	if Input.is_action_just_pressed("attack_2"):
		change_state(states.ATTACK_2)

func get_input_block():
	check_flip_on_x_axis()
	
	if not Input.is_action_pressed("block"):
		change_state(states.IDLE)
	
	if Input.is_action_pressed("sit_down"):
		change_state(states.SIT)
	
	if check_is_on_lader():
		change_state(states.CLIMB)
	
	if Input.is_action_just_pressed("attack_1"):
		change_state(states.ATTACK_1)
	
	if Input.is_action_just_pressed("attack_2"):
		change_state(states.ATTACK_2)

func get_input_dead():
	pass

func get_input_run():
	get_input_horizontal_movement()
	check_flip_on_x_axis()
	get_input_jump_movement()
	
	if velocity.x == 0:
		change_state(states.IDLE)
	elif not Input.is_action_pressed("run"):
		change_state(states.WALK)
	
	if Input.is_action_pressed("block"):
		change_state(states.BLOCK)
	
	if Input.is_action_pressed("sit_down"):
		change_state(states.SIT)
	
	if check_is_on_lader():
		change_state(states.CLIMB)
	
	if Input.is_action_just_pressed("attack_1"):
		change_state(states.ATTACK_1)
	
	if Input.is_action_just_pressed("attack_2"):
		change_state(states.ATTACK_2)
	
	if velocity.y != 0 and not is_on_floor():
		change_state(states.JUMP)

func get_input_walk():
	get_input_horizontal_movement()
	check_flip_on_x_axis()
	get_input_jump_movement()
	
	if velocity.x == 0:
		change_state(states.IDLE)
	elif Input.is_action_pressed("run"):
		change_state(states.RUN)
	
	if Input.is_action_pressed("block"):
		change_state(states.BLOCK)
	
	if Input.is_action_pressed("sit_down"):
		change_state(states.SIT)
	
	if check_is_on_lader():
		change_state(states.CLIMB)
	
	if Input.is_action_just_pressed("attack_1"):
		change_state(states.ATTACK_1)
	
	if Input.is_action_just_pressed("attack_2"):
		change_state(states.ATTACK_2)
	
	if velocity.y != 0 and not is_on_floor():
		change_state(states.JUMP)

func get_input_jump():
	get_input_horizontal_movement()
	check_flip_on_x_axis()
	
	if velocity.y > 0 and velocity.y < 20:
		animation_player.play("jump_down")
	
	if check_is_on_lader():
		change_state(states.CLIMB)
	
	if Input.is_action_just_pressed("attack_2"):
		change_state(states.ATTACK_2)
		movement_push = Vector2(10, 100)
		
	
	if is_on_floor():
		if velocity.x == 0:
			change_state(states.IDLE)
		else:
			if Input.is_action_pressed("run"):
				change_state(states.RUN)
			else:
				change_state(states.WALK)

func get_input_idle():
	get_input_horizontal_movement()
	get_input_jump_movement()
	
	if velocity.x != 0:
		if Input.is_action_pressed("run"):
			change_state(states.RUN)
		else:
			change_state(states.WALK)
	
	if Input.is_action_pressed("block"):
		change_state(states.BLOCK)
	
	if Input.is_action_pressed("sit_down"):
		change_state(states.SIT)
	
	if check_is_on_lader():
		change_state(states.CLIMB)
	
	if Input.is_action_just_pressed("attack_1"):
		change_state(states.ATTACK_1)
	
	if Input.is_action_just_pressed("attack_2"):
		change_state(states.ATTACK_2)
	
	if velocity.y != 0 and not is_on_floor():
		change_state(states.JUMP)

func get_input_climb_vertical_movement():
	velocity.y = Input.get_axis("climb_up", "climb_down",) * increased_speed

func get_input_horizontal_movement():
	velocity.x = Input.get_axis("left", "right") * current_speed

func get_input_jump_movement():
	if Input.is_action_just_pressed("jump"):
		velocity.y -= jump_speed

func check_flip_on_x_axis():
	var buffer = Input.get_axis("left", "right")
	if buffer < 0:
		collision_shape.scale.x = -1
		attack_collision_root.scale.x = -1
		sprite.flip_h = true
	if buffer > 0:
		collision_shape.scale.x = 1
		attack_collision_root.scale.x = 1
		sprite.flip_h = false

func set_camera_limits(limit_left, limit_right, limit_bottom, limit_top = 0):
	$Camera2D.limit_left = limit_left
	$Camera2D.limit_right = limit_right
	$Camera2D.limit_top = limit_top
	$Camera2D.limit_bottom = limit_bottom

func check_is_on_lader() -> bool:
	return (is_on_lader[0] or is_on_lader[1]) and (Input.is_action_pressed("climb_up") or Input.is_action_pressed("climb_down"))

func change_is_on_lader_state(value):
	for i in 2:
		if is_on_lader[i] != value:
			is_on_lader[i] = value
			return


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["attack_1", "attack_2", "hit"]:
		change_state(states.IDLE)
	if anim_name == "death":
		hide()

func _on_climb_timer_timeout() -> void:
		change_state(states.JUMP)

func _on_attack_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(damage)

func _on_attack_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(damage)

func _on_block_timer_timeout() -> void:
	block_is_reloading = true
	block_reload_timer.start()
	change_state(states.IDLE)

func _on_block_reload_timer_timeout() -> void:
	block_is_reloading = false
