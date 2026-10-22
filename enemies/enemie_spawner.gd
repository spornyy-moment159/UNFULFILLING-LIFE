class_name EnemieSpawner extends Node2D

const ENEMY_PATH_DICTIONARY = {
	EnemyBase.types.FLYING_EYE: "res://enemies/flying_eye/flying_eye.tscn",
	EnemyBase.types.SKELETON: "res://enemies/skeleton/skeleton.tscn",
	EnemyBase.types.GOBLIN: "res://enemies/goblin/goblin.tscn",
	EnemyBase.types.MUSHROOM: "res://enemies/mushroom/mushroom.tscn",
}

@export var enemies_root: Node
@export var type: EnemyBase.types

func set_enemies_root(root: Node):
	enemies_root = root

func set_random_enemy_type():
	set_enemy_type(randi_range(0, 3))

func set_enemy_type(init_type: EnemyBase.types):
	type = init_type

func spawn_enemy():
	var enemie = load(ENEMY_PATH_DICTIONARY[type]).instantiate()
	enemies_root.add_child(enemie)
	enemie.position = position
	if type == EnemyBase.types.FLYING_EYE:
		enemie.start()
