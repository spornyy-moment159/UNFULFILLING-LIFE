class_name HUD extends CanvasLayer

@export var hp_is_showed: bool = true

func _ready() -> void:
	if not hp_is_showed:
		$MarginContainer/HBoxContainer/HPCounter.hide()
	GlobalsSignals.player_hp_changed.connect(update_hp)

func update_hp(value):
	var hearts = $MarginContainer/HBoxContainer/HPCounter.get_children()
	for heart_number in hearts.size():
		if heart_number < value:
			hearts[heart_number].visible = true
		else:
			hearts[heart_number].visible = false

func update_coin(collected_coins, coins_number):
	$MarginContainer/HBoxContainer/CoinCounter.text = str(collected_coins) + "/" + str(coins_number)
