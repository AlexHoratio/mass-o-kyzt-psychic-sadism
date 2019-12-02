extends Node2D
class_name PsychicKyztling

var data
export var debug = false

var able_to_dispense = true

func _ready():
	add_to_group("PsychicKyztlings")
	data.connect("position_updated", self, "update_arrow")

func _process(delta):
	position = data.position
	
func update_arrow(movement_vector):
	$arrow.set_target_rotation(movement_vector.angle() + PI)
		
	if debug:
		print($arrow.turning_direction)
		
func dispense_psychic_sybin():
	if get_tree().get_nodes_in_group("psychic_sybin").size() < 100:
		if able_to_dispense and hive.get_voice() == data:
			var psychic_sybin = load("res://Verticle Slice/Prefabs/Bullets/psychic_sybin.tscn").instance()
			psychic_sybin.apply_central_impulse(Vector2(1, 0).rotated($arrow.rotation + PI + sin(2*PI*randf())*PI/8)*(95 + 10*randf()))
			psychic_sybin.apply_torque_impulse(sin(2*PI*randf())*2*PI)
			psychic_sybin.position = position
			psychic_sybin.parent = self
			get_parent().add_child(psychic_sybin)
		
func pickup_sybin():
	print("YAY THAKNS!:D")
	#propagate powerup back to KyztlingData, create rainbow glow in PsychicSpirit, 
	# improve HP of ColonyKyztling, temporary/falling-off particle fx on ColonyKyztling
		
func die():
	queue_free()

func _on_sybin_timer_timeout() -> void:
	able_to_dispense = true
