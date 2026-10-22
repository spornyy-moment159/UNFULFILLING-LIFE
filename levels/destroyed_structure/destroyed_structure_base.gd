extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var hp = 100:
	set(value):
		hp = value
		animation_player.play("hit")
		if hp <= 0:
			destroy()

func hit(value):
	hp -= value

func destroy():
	queue_free()
