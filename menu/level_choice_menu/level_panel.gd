class_name LevelPanel extends PanelContainer

const FALSE = preload("uid://bnemurmw60oig")
const TRUE = preload("uid://cff34dfy3yymn")

@onready var coin_counter: Label = $MarginContainer/VBoxContainer/HBoxContainer/CoinCounter
@onready var title: Label = $MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var description: RichTextLabel = $MarginContainer/VBoxContainer/Description
@onready var title_texture: TextureRect = $MarginContainer/VBoxContainer/TitleTexture
@onready var level_button: Button = $LevelButton
@onready var level_completed_icon: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/LevelCompletedIcon
@onready var coin_icon: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/CoinIcon

var level_id: GlobalsScenes.id

func init_set(level_number: int):
	level_id = SaveSystem.get_level_id(level_number)
	if SaveSystem.get_complete_state_of_level(level_number):
		level_completed_icon.texture = TRUE
	else:
		level_completed_icon.texture = FALSE
	title.text = FileAccess.open(GlobalsScenes.get_level_title_file_path(level_id), FileAccess.READ).get_as_text()
	description.text = FileAccess.open(GlobalsScenes.get_level_description_file_path(level_id), FileAccess.READ).get_as_text()
	title_texture.texture = load(GlobalsScenes.get_level_title_texture_file_path(level_id))
	if SaveSystem.get_number_of_coins_in_level(level_number) != 0:
		coin_counter.text = str(SaveSystem.get_number_of_collected_coins_in_level(level_number)) + "/" + str(SaveSystem.get_number_of_coins_in_level(level_number))
	else:
		coin_counter.hide()
		coin_icon.hide()

func _on_level_button_pressed() -> void:
	GlobalsSignals.change_scene_button_pressed.emit(level_id)
