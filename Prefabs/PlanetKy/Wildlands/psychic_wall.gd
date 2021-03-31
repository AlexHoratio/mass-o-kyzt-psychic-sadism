extends Line2D

var WallData

func _ready() -> void:
	add_to_group("psychic_walls")
	self_modulate.a = 0
	convert_line_into_wall()
	
func convert_line_into_wall():
	for i in range(points.size() - 1):
		var wall_segment = load("res://Verticle Slice/Prefabs/Environment/psychic_wall_segment.tscn").instance()
		wall_segment.add_point(points[i])
		wall_segment.add_point(points[i + 1])
		wall_segment.UID = i
		add_child(wall_segment)
		
		var joint = load("res://Verticle Slice/Prefabs/Environment/psychic_joint.tscn").instance()
		joint.position = points[i]
		wall_segment.add_child(joint)
		
		var joint_again = load("res://Verticle Slice/Prefabs/Environment/psychic_joint.tscn").instance()
		joint_again.position = points[i+1]
		wall_segment.add_child(joint_again)
		
func destroy_segment_by_uid(UID: int) -> void:
	for wall_segment in get_children():
		if wall_segment in get_tree().get_nodes_in_group("psychic_segment"):
			if wall_segment.UID == UID:
				wall_segment.destroy()
		
		
#var TIME = 0
#
#func _ready() -> void:
#	pass
#
#func _process(delta: float) -> void:
#	TIME += delta
#	default_color.h = 0.8 + 0.1*sin(TIME)
