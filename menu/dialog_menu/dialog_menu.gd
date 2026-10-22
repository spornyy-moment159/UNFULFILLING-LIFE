class_name DialogMenu extends CanvasLayer

@onready var rich_text_label: RichTextLabel = $Control/MarginContainer/PanelContainer/VBoxContainer/RichTextLabel
@onready var next_button: Button = $Control/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/NextButton
@onready var bonus_button: Button = $Control/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/BonusButton
@onready var person_1: PanelContainer = $Control/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Person1
@onready var person_2: PanelContainer = $Control/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Person2
@onready var person_1_texture: TextureRect = $Control/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Person1/Person1Texture
@onready var person_2_texture: TextureRect = $Control/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Person2/Person2Texture


@export var textures: Array[Texture2D]
@export var checkpoint_number: int = 1
@export var DIALOG_TEXT_PATH: String = "res://resourses/text_files/level_02/dialog_text.txt"
const STYLE_PANEL = preload("uid://dkot7g6lntlnj")
const STYLE_PANEL_DIALOG_ACTIVE = preload("uid://8vuw08dy3106")

var text_file: FileAccess
var current_person: int:
	set(value):
		current_person = value
		allocate_current_person()
var current_line: String

func start():
	person_1_texture.texture = textures[0]
	person_2_texture.texture = textures[1]
	
	text_file = FileAccess.open(DIALOG_TEXT_PATH,FileAccess.READ)
	current_person = int(text_file.get_line())
	allocate_current_person()
	next()

func allocate_current_person():
	if current_person == 1:
		person_1.add_theme_stylebox_override("panel", STYLE_PANEL_DIALOG_ACTIVE)
		person_2.add_theme_stylebox_override("panel", STYLE_PANEL)
	if current_person == 2:
		person_1.add_theme_stylebox_override("panel", STYLE_PANEL)
		person_2.add_theme_stylebox_override("panel", STYLE_PANEL_DIALOG_ACTIVE)

func next():
	current_line = text_file.get_line()
	
	if current_line == "*end*":
		GlobalsSignals.check_point_reached.emit(checkpoint_number)
		return
	
	if current_line == "5":
		change_person_texture(int(text_file.get_line()), int(text_file.get_line()))
		current_line = text_file.get_line()
	
	if current_line == "4":
		change_disabled_state_main_button()
		change_visible_state_bonus_button()
		change_bonus_button_text(text_file.get_line())
		current_line = text_file.get_line()
	
	if current_line == "3":
		change_disabled_state_main_button()
		change_visible_state_bonus_button()
		current_line = text_file.get_line()
	
	if current_line == "1" or current_line == "2":
		current_person = int(current_line)
		current_line = text_file.get_line()
	
	rich_text_label.text = current_line

func change_person_texture(person_number: int, new_texture_number: int):
	if person_number == 1:
		person_1_texture.texture = textures[new_texture_number]
	if person_number == 2:
		person_2_texture.texture = textures[new_texture_number]

func change_bonus_button_text(new_text: String):
	bonus_button.text = new_text

func change_disabled_state_main_button():
	next_button.disabled = not next_button.disabled

func change_visible_state_bonus_button():
	bonus_button.visible = not bonus_button.visible


func _on_next_button_pressed() -> void:
	next()


func _on_bonus_button_pressed() -> void:
	next()
