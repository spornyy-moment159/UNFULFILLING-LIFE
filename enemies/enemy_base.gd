class_name EnemyBase extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_root: Node2D = $AttackRoot
@onready var attack_mark: Marker2D = $AttackRoot/AttackMark


enum states{ MOVE, ATTACK, HIT, DEAD, WAIT }
enum types{ FLYING_EYE, SKELETON, GOBLIN, MUSHROOM}


var states_parameters = {
	states.MOVE: ["state_move", "move"],
	states.ATTACK: ["state_attack", "attack"],
	states.HIT: ["state_hit", "hit"],
	states.DEAD: ["state_dead", "dead"],
	states.WAIT: ["state_wait", "wait"],
}

@export var hp: int = 5:
	set(value):
		change_state(states.HIT)
		if value <= 0:
			is_dead = true
			change_state(states.DEAD)
		hp = value
@export var damage: int = 1
var player_position: Vector2 = Vector2.ZERO
var is_dead = false
var gravity = 500
var current_state: String = states_parameters[states.MOVE][0]

func _ready() -> void:
	GlobalsSignals.player_died.connect(player_died)

func player_died():
	change_state(states.WAIT)

func get_anim_name(state: states):
	return states_parameters[state][1]

func check_flip_on_x_axis():
	var direction = player_position.x - global_position.x
	if direction < 0:
		collision_shape.scale.x = -1
		attack_root.scale.x = -1
		sprite.flip_h = true
	if direction > 0:
		collision_shape.scale.x = 1
		attack_root.scale.x = 1
		sprite.flip_h = false

func hit(damage_value):
	if not is_dead:
		hp -= damage_value

func change_state(state: states):
	if current_state == states_parameters[states.DEAD][0]:
		return
	current_state = states_parameters[state][0]
	$AnimationPlayer.play(states_parameters[state][1])

func state_wait():
	pass

func state_move(delta):
	pass

func state_attack():
	pass

func state_hit():
	pass

func state_dead():
	pass

func update_anim_names(prefix: String):
	for state in 5:
		states_parameters[state][1] = prefix + states_parameters[state][1]
