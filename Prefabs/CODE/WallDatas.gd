extends Node

func _ready() -> void:
	generate_real_walls()
	hide_wall_placeholders()
	
func hide_wall_placeholders():
	for walldata in get_tree().get_nodes_in_group("wall_datas"):
		walldata.visible = false
	
func generate_real_walls():
	for walldata in get_tree().get_nodes_in_group("wall_datas"):
		var ColonyWall = load("res://Verticle Slice/Prefabs/Environment/colony_wall.tscn").instance()
		ColonyWall.set_points(walldata.get_points())
		walldata.ColonyWall = ColonyWall
		ColonyWall.WallData = walldata
		ColonyWall.connect("segment_exploded", walldata, "segment_exploded")
		get_node("../ColonyView/walls").add_child(ColonyWall)
		
		var PsychicWall = load("res://Verticle Slice/Prefabs/Environment/psychic_wall.tscn").instance()
		PsychicWall.set_points(walldata.get_points())
		walldata.PsychicWall = PsychicWall
		PsychicWall.WallData = walldata
		get_node("../PsychicView/walls").add_child(PsychicWall)
		
#		var psychic_wall = load("res://Verticle Slice/Prefabs/Environment/psychic_wall.tscn").instance()
#		psychic_wall.set_points(wall.get_points())
#		get_node("../PsychicView/walls").add_child(psychic_wall)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
#	generate_colony_walls()
#	generate_psychic_walls()
#
#	hide_walls()
	
#func hide_walls():
#	for wall in get_tree().get_nodes_in_group("wall_data"):
#		wall.self_modulate.a = 0
#
#func generate_colony_walls():
#	for wall in get_tree().get_nodes_in_group("wall_data"):
#		var large_wall = load("res://Verticle Slice/Prefabs/Environment/large_wall.tscn").instance()
#		large_wall.set_points(wall.get_points())
#		get_node("../ColonyView/walls").add_child(large_wall)
#
#		large_wall.connect("segment_exploded", self, "segment_destroyed", [large_wall])
#
#func generate_psychic_walls(): 
#	for wall in get_tree().get_nodes_in_group("wall_data"):
#		var psychic_wall = load("res://Verticle Slice/Prefabs/Environment/psychic_wall.tscn").instance()
#		psychic_wall.set_points(wall.get_points())
#		get_node("../PsychicView/walls").add_child(psychic_wall)
#
#func segment_destroyed(segment, large_wall):
#	for wall in get_tree().get_nodes_in_group("psychic_walls"):
#		if segment == wall.get_segment_with_points(segment.points[0], segment.points[1]):
#			segment.queue_free()