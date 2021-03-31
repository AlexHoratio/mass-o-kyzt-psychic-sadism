extends Node2D

var radius = 1000
var number_of_vertices_to_edge = 10
var debug_timer = 0

func _ready() -> void:
	generate_paths()
	
func generate_paths():
	var current_angle = 0
	
	for i in range(3):
		var points = PoolVector2Array([])
		points.append(Vector2(0, 0)) #center
		points.append(Vector2(radius/number_of_vertices_to_edge, 0).rotated(current_angle))
		
		var path = load("res://Verticle Slice/Prefabs/Environment/path.tscn").instance()
		path.sacred_angle = current_angle
		path.points = points
		path.max_radius = radius
		path.radius_left = path.max_radius
		add_child(path)
		
		current_angle += 2*PI/3 
