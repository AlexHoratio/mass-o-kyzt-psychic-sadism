extends Node2D
class_name PsychicViper

var data
export var debug = false

func _ready():
	data.connect("position_updated", self, "update_arrow")

func _process(delta):
	position = data.position
	
func update_arrow(movement_vector):
	$arrow.set_target_rotation(movement_vector.angle() + PI)
	
#	if delta_angle < -0.1:
#		$arrow.turning_direction = $arrow.TURN.LEFT
#	elif delta_angle > 0.1:
#		$arrow.turning_direction = $arrow.TURN.RIGHT
#	else:
#		$arrow.turning_direction = $arrow.TURN.MIDDLE
		
	if debug:
		print($arrow.turning_direction)
		
func die() -> void:
	queue_free()