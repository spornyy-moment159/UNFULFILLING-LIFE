extends Area2D

@onready var advice: Sprite2D = $Advice
@onready var delay_timer: Timer = $DelayTimer

@export var texture: Texture2D
@export var texture_height: int
@export var time_delay_in_seconds: float = 0.1

@export var texture_alt: Texture2D
@export var texture_height_alt: int
@export var is_show_alt = false

var player_watch_advice = false

func _process(_delta: float) -> void:
	if delay_timer.is_stopped() and not player_watch_advice and advice.visible:
		advice.hide()


func _on_body_entered(_body: Node2D) -> void:
	player_watch_advice = true
	if delay_timer.is_stopped():
		delay_timer.start(time_delay_in_seconds)


func _on_body_exited(_body: Node2D) -> void:
	player_watch_advice = false
	if delay_timer.is_stopped():
		delay_timer.start(time_delay_in_seconds / 4)


func _on_delay_timer_timeout() -> void:
	
	advice.texture = texture
	advice.position.y = -(41 + texture_height / 2.0)
	if advice.visible:
		advice.hide()
	else:
		advice.show()
		if is_show_alt:
			texture = texture_alt
			texture_height = texture_height_alt
		if time_delay_in_seconds > 5.0:
			delay_timer.start(5)
		time_delay_in_seconds = 0.5
