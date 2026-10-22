extends Area2D


func _on_body_entered(body: Player) -> void:
	body.change_is_on_lader_state(true)


func _on_body_exited(body: Player) -> void:
	body.change_is_on_lader_state(false)
