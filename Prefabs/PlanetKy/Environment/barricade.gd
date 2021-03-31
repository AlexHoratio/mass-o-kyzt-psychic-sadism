extends Node2D

var resolution = 4
var radius = 50

func _ready() -> void:
	generate_wall()
	
func generate_wall() -> void:
	
	var points = PoolVector2Array([])
	
	var current_angle = 0
	for i in range(resolution):
		
		points.append(Vector2(radius, 0).rotated(current_angle))
		
		current_angle += PI/resolution
	
	var large_wall = load("res://Verticle Slice/Prefabs/Environment/large_wall.tscn").instance()
	large_wall.points = points
	add_child(large_wall)
