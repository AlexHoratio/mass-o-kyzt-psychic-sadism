extends Line2D

var max_radius = 1000
var radius_left = 1000
var sacred_angle = -666

var divergent = false

var dead_zone_sensitivity = 400

func _ready() -> void:
	randomize()
	if sacred_angle != -666:
		propagate()
		
		if get_children().size() == 0:
			open_walls()
		
	apply_dirt_patches()
		
# Scan for nearby stone walls, delete the nearest vertex
func open_walls() -> void:
	var second_closest_wall = null
	var closest_wall = null
	var closest_distance = 999999
	
	#bug: doesn't select the correct wall segment
	for wall in get_tree().get_nodes_in_group("wall_segments"):
		# calculate distance from global_position + points[1]?
		var distance = (global_position + points[1]).distance_to(wall.points[0])
		if distance < closest_distance:
			closest_distance = distance
			second_closest_wall = closest_wall
			closest_wall = wall
	
	var gate_spawner = load("res://Prefabs/Hints/gate_spawner.tscn").instance()
	gate_spawner.global_position = closest_wall.points[0]
	get_node("/root/colony").add_child(gate_spawner)
	
	if second_closest_wall != null:
		second_closest_wall.queue_free()
	else:
		closest_distance = 999999
		for wall in get_tree().get_nodes_in_group("wall_segments"):
			var distance = (global_position + points[1]).distance_to(wall.points[0])
			if not(wall == closest_wall) and distance < closest_distance:
				closest_distance = distance
				second_closest_wall = wall
		
	if closest_wall != null:
		closest_wall.queue_free()
	
func point_in_dead_zone(point: Vector2) -> bool:
	for dead_zone in get_tree().get_nodes_in_group("pathgen_dead_zones"):
		if point.distance_to(dead_zone.position) < dead_zone_sensitivity:
			return true
	return false
	
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
		var vector
		if divergent:
			vector = Vector2(self_size, 0).rotated(sacred_angle)
		else:
			vector = Vector2(self_size, 0).rotated(sacred_angle + sin(2*PI*randf())*PI/6)
		new_path.points = PoolVector2Array([Vector2(0, 0), vector])
		new_path.radius_left = radius_left - (0 if divergent else self_size)
		new_path.max_radius = max_radius
		add_child(new_path)
