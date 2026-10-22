extends "res://levels/level_base.gd"

const ENEMIE_SPAWNER = preload("uid://ddgwmhj018btu")

@onready var enemy_root: Node = $Pausable/EnemyRoot
@onready var orb_root: Node2D = $Pausable/EnemyRoot/OrbRoot
@onready var enemies_spawn_path_follow: PathFollow2D = $Pausable/EnemyRoot/Path2D/EnemiesSpawnPathFollow

var spawn_time = 10

func _ready() -> void:
	super._ready()
	GlobalsSignals.check_point_reached.connect(checkpoint_holder)
	GlobalsSignals.player_died.connect(end_level)
	
	GlobalsParametes.set_orb_root($Pausable/EnemyRoot/OrbRoot)
	
	GlobalsParametes.set_path_follow_for_flying_eye($Pausable/EnemyRoot/FlyingEyePath1/PathFollow2D)
	GlobalsParametes.set_path_follow_for_flying_eye($Pausable/EnemyRoot/FlyingEyePath2/PathFollow2D)
	GlobalsParametes.set_path_follow_for_flying_eye($Pausable/EnemyRoot/FlyingEyePath3/PathFollow2D)
	
	change_pause_state()
	show_dialog_menu()
	dialog_menu.start()

func end_level():
	$Pausable/EnemyRoot/EnemiesSpawnerTimer.stop()
	$Pausable/EnemyRoot/EnemiesSpawnerTimer/BustTimer.stop()
	$AnimationPlayer.play("level_end")

func checkpoint_holder(number_of_checkpoint: int):
	match number_of_checkpoint:
		1: 
			change_pause_state()
			hide_dialog_menu()

func spawn_enemy():
	enemies_spawn_path_follow.progress_ratio = randf_range(0, 1)
	var enemy_spawner_position = enemies_spawn_path_follow.position
	var spawner: EnemieSpawner = ENEMIE_SPAWNER.instantiate()
	spawner.set_random_enemy_type()
	spawner.set_enemies_root(enemy_root)
	enemy_root.add_child(spawner)
	spawner.position = enemy_spawner_position


func _on_enemies_spawner_timer_timeout() -> void:
	spawn_enemy()


func _on_bust_timer_timeout() -> void:
	spawn_time *= 0.9
	$Pausable/EnemyRoot/EnemiesSpawnerTimer.start(spawn_time)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SaveSystem.level_complete(level_number, coin_collected)
	player.deactivate_camera()
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.END_SCREEN)
