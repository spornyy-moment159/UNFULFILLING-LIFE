extends "res://levels/level_base.gd"

@onready var check_point_1_position_marker: Marker2D = $Pausable/CheckPointsRootNode/CheckPoint1PositionMarker

func _ready() -> void:
	super._ready()
	GlobalsSignals.check_point_reached.connect(checkpoint_reached)


func checkpoint_reached(_number: int):
	var pattern = world.tile_set.get_pattern(0) 
	var coord: Vector2 = world.local_to_map(check_point_1_position_marker.position)
	world.set_pattern(0, Vector2i(coord), pattern)
