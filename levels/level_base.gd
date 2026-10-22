extends Node

const ITEM = preload("uid://gdyvd7nulv53")
const LEVEL_EXIT = preload("uid://v17p8ajjb73x")

@onready var player: Player = $Pausable/PlayerRootNode/Player
@onready var player_spawn_point: Marker2D = $Pausable/PlayerSpawnPoint
@onready var level_exit_point: Marker2D = $Pausable/LevelExitPoint
@onready var level_exit: Area2D = $Pausable/LevelExitRootNode/LevelExit
@onready var world: TileMap = $Pausable/World
@onready var items: TileMap = $Pausable/Items
@onready var items_root_node: Node = $Pausable/ItemsRootNode
@onready var pause_menu: CanvasLayer = $WhenPaused/PauseMenu
@onready var hud: HUD = $Pausable/HUD
@onready var dialog_menu: DialogMenu = $WhenPaused/DialogMenu

@export_range(0, 4) var level_number = 0

var coin_number = 0
var coin_collected = 0
var dialog_is_active = false

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not dialog_is_active:
			change_pause_state()
		change_pause_menu_visible_state()

func _ready() -> void:
	init_items()
	level_exit.position = level_exit_point.position
	init_player()
	pause_menu.hide()
	
	
	GlobalsSignals.level_exit_reached.connect(level_exit_reached)
	GlobalsSignals.item_pickaped.connect(item_collected)


func item_collected(type: GlobalsParametes.items_types):
	if type == GlobalsParametes.items_types.COIN:
		coin_collected += 1
		hud.update_coin(coin_collected, coin_number)

func level_exit_reached():
	SaveSystem.level_complete(level_number, coin_collected)
	exit_to_level_choise_menu()

func restart_level():
	GlobalsSignals.change_scene_button_pressed.emit(SaveSystem.get_level_id(level_number))
	#for item in items_root_node.get_children():
		#item.queue_free()
	#player.position = player_spawn_point.position
	#level_exit.position = level_exit_point.position
	#hide_dialog_menu()
	#player.reset()
	#init_items()
	#change_pause_state()
	#change_pause_menu_visible_state()

func change_pause_menu_visible_state():
	if pause_menu.visible:
		pause_menu.hide()
	else:
		pause_menu.show()

func hide_dialog_menu():
	dialog_menu.hide()
	dialog_is_active = false

func show_dialog_menu():
	dialog_menu.show()
	dialog_is_active = true

func change_pause_state():
	get_tree().paused = not get_tree().paused

func init_player():
	player.position = player_spawn_point.position
	var map_size = world.get_used_rect()
	var cell_size = world.tile_set.tile_size
	
	player.set_camera_limits(
		(map_size.position.x) * cell_size.x, 
		(map_size.end.x) * cell_size.x,
		(map_size.end.y) * cell_size.y,
		)

func init_items():
	items.hide()
	for map_coord in items.get_used_cells(0):
		var item_type = items.get_cell_tile_data(0, map_coord).get_custom_data("type")
		var item: Item = ITEM.instantiate()
		items_root_node.add_child(item)
		item.spawn(item_type, items.map_to_local(map_coord))
	 
	coin_collected = 0
	coin_number = SaveSystem.get_number_of_coins_in_level(level_number)
	hud.update_coin(coin_collected, coin_number)

func exit_to_level_choise_menu():
	player.deactivate_camera()
	GlobalsSignals.change_scene_button_pressed.emit(GlobalsScenes.id.LEVEL_CHOICE_MENU)


func _on_exit_button_pressed() -> void:
	exit_to_level_choise_menu()

func _on_continue_button_pressed() -> void:
	change_pause_state()

func _on_restart_button_pressed() -> void:
	restart_level()
