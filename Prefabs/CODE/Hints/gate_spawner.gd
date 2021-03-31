extends Node2D



func _ready() -> void:
	pass

func get_spawnpoint() -> Vector2:
	var buffer = 100
	var radius_from_center = position.distance_to(Vector2.ZERO)
	var angle_to_center = position.angle_to_point(Vector2.ZERO)
	var spawnpoint = Vector2(radius_from_center + buffer, 0).rotated(angle_to_center)
	
	return spawnpoint
