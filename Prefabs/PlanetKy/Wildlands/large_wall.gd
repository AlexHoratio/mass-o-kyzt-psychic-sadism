extends Line2D

signal segment_exploded

var WallData

func _ready() -> void:
	add_to_group("colony_walls")
	self_modulate.a = 0
	convert_line_into_wall()
	
func segment_exploded(wall_segment):
	emit_signal("segment_exploded", wall_segment) #propagates signal
	
func convert_line_into_wall():
	for i in range(points.size() - 1):
		var wall_segment = load("res://Verticle Slice/Prefabs/Environment/colony_wall_segment.tscn").instance()
		wall_segment.add_point(points[i])
		wall_segment.add_point(points[i + 1])
		wall_segment.UID = i
		add_child(wall_segment)
		wall_segment.connect("explode", self, "segment_exploded", [wall_segment])
		
		var joint = load("res://Verticle Slice/Prefabs/Environment/joint.tscn").instance()
		joint.position = points[i]
		wall_segment.add_child(joint)
		
		var joint_again = load("res://Verticle Slice/Prefabs/Environment/joint.tscn").instance()
		joint_again.position = points[i+1]
		wall_segment.add_child(joint_again)
