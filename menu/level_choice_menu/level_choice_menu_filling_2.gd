extends MarginContainer

@onready var level_panel_container: HBoxContainer = $ScrollContainer/LevelPanelContainer

const LEVEL_PANEL_UNACTIVE = preload("uid://cvllh3aghsx35")
const LEVEL_PANEL = preload("uid://iqtqlnopumtp")


func _ready() -> void:
	for levels_number in SaveSystem.number_of_levels:
		if SaveSystem.check_available_level(levels_number):
			var level_panel: LevelPanel = LEVEL_PANEL.instantiate()
			level_panel_container.add_child(level_panel)
			level_panel.init_set(levels_number)
		else:
			var level_panel = LEVEL_PANEL_UNACTIVE.instantiate()
			level_panel_container.add_child(level_panel)
