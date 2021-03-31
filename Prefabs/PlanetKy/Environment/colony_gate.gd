extends Line2D

var barricade_distance = 350
var barricade_resolution = 4
var barricade_radius = 200

# this obj should only ever have 2 points!

func _ready() -> void:
	generate_barricade()
	self_modulate.a = 0
	
func generate_barricade() -> void:
	
	var midpoint = points[0].linear_interpolate(points[1], 0.5)
	var angle_to_mid = midpoint.angle_to_point(Vector2(0, 0))
	
	var barricade = load("res://Prefabs/Entities/barricade.tscn").instance()
	barricade.position = midpoint + Vector2(barricade_distance, 0).rotated(angle_to_mid)
	barricade.rotation = barricade.global_position.angle_to_point(Vector2(0, 0)) + PI/2
	barricade.resolution = barricade_resolution
	barricade.radius = barricade_radius
	add_child(barricade)
