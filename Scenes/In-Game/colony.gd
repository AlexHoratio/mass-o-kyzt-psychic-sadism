extends Node2D

var kyztling_controlled = true
var colony_radius = 1000

#DEBUG
var line_list = []
var path_list = []
var stickiness = 100

func _ready() -> void:
	generate_walls()
	generate_roads()
	
	if kyztling_controlled:
		generate_kyztlings()
	else:
		generate_enslaved_kyztlings()
		generate_vipers()
		set_player_position()
	
func _process(delta: float) -> void:
	update()
	
func _draw() -> void:
	for line in line_list:
		if true:
			draw_line(line[0], line[1], Color(0.8, 0.8, 0.8, 1), clamp(line[2]*50, 5, 50), false)
			
	for path in path_list:
		draw_line(path[0], path[1], Color("413b23"), 5)
	
# Currently does nothing, since the Colony is pre-determined. 
# In future, will require a radius, is that it? Final params depend on the algorithm
# TODO: Re positioning: radial vertex noise, transverse vertex noise
func generate_walls() -> void:
	#in future; generate a circular (uneven distance between vertices) stone wall with a gate?
	var center_point = Vector2(0, 0)
	var radius = colony_radius #get value from JSON?
	var transverse_intervertex_length = 100 #get value from JSON?
	# this value is the distance between each vertex along the circumference of the wall
	
	var number_of_vertices: int = int(PI*2*radius/transverse_intervertex_length)
	
	var vertices = PoolVector2Array([])
	var angle_increment = 2*PI/number_of_vertices
	
	for i in range(number_of_vertices + 1):
		vertices.append(Vector2(radius, 0).rotated(angle_increment*i))
		
	var colony_wall = load("res://Verticle Slice/Prefabs/Environment/colony_wall.tscn").instance()
	colony_wall.points = vertices
	add_child(colony_wall)

func generate_roads() -> void:
	var colony_path_generator = load("res://Verticle Slice/Prefabs/Environment/colony_path_generator.tscn").instance()
	
	colony_path_generator.radius = colony_radius
	
	add_child(colony_path_generator)

# Generate a map of roads. This should be somehow stored in JSON for weak permanence.
func generate_roads_old_alg() -> void:
	#variables
	var protopoints = PoolVector2Array([])
	var density = 50
	var number_of_protopoints = (2*PI*colony_radius)/density
	
	#generating the actual protopoints based on parameters
	for i in range(number_of_protopoints):
		protopoints.append(Vector2(colony_radius*sqrt(randf()), 0).rotated(2*PI*randf()))
		
	var protopoint_ranking_dict = {} #this is data structure for holding info about each point
	#var stickiness = density
	for point in protopoints:
		#						[score_value, neighbours]
		protopoint_ranking_dict[point] = [0, []]
		
		#checking interactions with every other point
		for other_point in protopoints:
			if not(other_point == point):
				var interpoint_distance = point.distance_to(other_point)
				#disqualifier
				if interpoint_distance < stickiness*2:
					
					# normal curve equation: (1/sqrt(2*PI))*pow(e, -pow(x, 2)/2), mean=0, s.d=0
					# score_value is a normal curve function that takes in x(interpoint_distance - 25) and gives back y(score_value)
					
					#generates a score value
					var score_value: float = (1/(sqrt(2*PI)))*pow(2.718281828459045, -pow(interpoint_distance - stickiness, 2)/2)
					protopoint_ranking_dict[point][0] += score_value
					protopoint_ranking_dict[point][1].append(other_point) # <- other_point is a friend of point, added to dict
					
					#for drawing lines
					if get_point_linestart(other_point) == []:
						line_list.append([point, other_point, score_value])
				
				else: #purely to make acquisition of 0 points explicit
					protopoint_ranking_dict[point][0] += 0
				
		# try to kill point if it has no friends
		if protopoint_ranking_dict[point][1].size() == 0:
			point = Vector2(0, 0)
	
	var i = 0
	while i < protopoints.size():
		# kill point if it has no friends
		# if it fails the check, kill it
		if protopoints[i] == Vector2(0, 0) or protopoint_ranking_dict[protopoints[i]][1].size() == 0:
			protopoints.remove(i)
		# if it passes the check, i += 1 and print debug icon
		else:
			var debug = Sprite.new()
			debug.texture = load("res://icon.png")
			debug.position = protopoints[i]
			debug.scale = Vector2(0.1, 0.1)
			debug.add_to_group("debug_icons")
			add_child(debug)
			
			i += 1
	
	#now for the path gen bit
	
	#calculating starting point based on its score value, or stickiness value, whatever
	var current_point: Vector2 
	var stickiest_value = 0
	
	# simple maxing loop
	for entry in protopoint_ranking_dict.keys():
		if protopoint_ranking_dict[entry][0] > stickiest_value:
			stickiest_value = protopoint_ranking_dict[entry][0]
			current_point = entry
	
	# :: BROKEN ALGORITHM ::
	# vVvvvvvvvvvvvvvvvvvvVv
	# 1. iterate through current_point's friends,
	# if friend ->    1a. find its furthest friend that isn't in used_points
	# if no friend -> 1b. find closest neighbour that isn't in used_points
	# 2. add all skipped points to used_points
	# 3. add path from current_point to new_point to path_lines
	# 4. set current_point = new_point
	# ^^^^^^^^^^^^^^^^^^^^^^
	
	
	# :: ANOTHER BROKEN ALGORITHM ::
#	var line = line_list[0]
#	var path_list = PoolVector2Array([])
#
#	while path_list.size() < 10:
#		var point = line[0]
#		path_list.append(point)
#		print(path_list)
#		print(line)
#
#		#if line[1] exists in line_list as line[0], but is not yet in path_list
#		if not(line[1] in path_list):
#			var new_line = get_point_linestart(line[1])
#
#			if not(new_line == []):
#				line = new_line 
#			else:
#				print("new_line was == []!")
#				break
##		else:
##			print("line[1] was in path list!")
##			break
#
#	var path = load("res://Verticle Slice/Prefabs/Environment/path.tscn").instance()
#	path.points = path_list
#	add_child(path)
	
	
# given a point, does this point start a line array in line_list? if so, return the line it starts
func get_point_linestart(point: Vector2) -> Array:
	for line in line_list:
		if point == line[0]:
			return line
	return []

func is_point_in_path_list(point: Vector2) -> bool:
	for line in path_list:
		if point == line[0] or point == line[1]:
			return true
	return false
	
# called every vslider update
func regenerate_roads() -> void:
	# set everything to pre-regen state
	line_list = []
	path_list = []
	for node in get_tree().get_nodes_in_group("debug_icons"):
		node.queue_free()
	
	# generate stuff
	generate_roads()

func generate_kyztlings() -> void:
	pass
	
# Generate enslaved Kyztlings. Should be similar to generate_kyztlings()
func generate_enslaved_kyztlings() -> void:
	pass
	
# Generate Vipers around the Colony
func generate_vipers() -> void:
	pass
	
# This should place the player at a random point around the walls of the Colony
# Base it on which direction the player is coming from?
func set_player_position() -> void:
	pass 

func _on_VSlider_value_changed(value: float) -> void:
	stickiness = value
	regenerate_roads()
