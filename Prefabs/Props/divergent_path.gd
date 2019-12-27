extends Line2D

var max_radius = 1000
var radius_left = 1000
var sacred_angle = -666

func _ready() -> void:
	randomize()
	if sacred_angle != -666:
		propagate()
	apply_dirt_patches()
	
	if radius_left/max_radius < 0.5:
		if randf()*radius_left/max_radius > 0.2:
			var divergent_path = load("res://Prefabs/Props/path.tscn").instance()
			
			add_child(divergent_path)
	
func apply_dirt_patches() -> void:
	for i in range(2):
		var dirt_patch = load("res://Prefabs/Props/dirt_patch.tscn").instance()
		dirt_patch.position = points[i]
		add_child(dirt_patch)

# Determine whether to create a new branch, and then create that branch
func propagate() -> void: 
	var self_angle = -points[0].angle_to_point(points[1])
	var self_size = points[1].length()

	if radius_left <= self_size:
		return 

	if randf() <= 0.7 or true:
		var new_path = load("res://Verticle Slice/Prefabs/Environment/path.tscn").instance()
		new_path.position = points[1]
		new_path.sacred_angle = sacred_angle
		var vector = Vector2(self_size, 0).rotated(sacred_angle + sin(2*PI*randf())*PI/3)
		new_path.points = PoolVector2Array([Vector2(0, 0), vector])
		new_path.radius_left = radius_left - self_size
		add_child(new_path)