class_name Background extends ParallaxBackground

@export_range(0, 100) var scroll_speed = 50

func _process(delta: float) -> void:
	scroll_offset.x -= scroll_speed * delta

func set_scroll_offset_x(value):
	scroll_offset.x = value

func get_scroll_offset_x() -> float:
	return scroll_offset.x
