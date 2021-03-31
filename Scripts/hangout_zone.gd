extends Node2D

var max_wander_radius = 250
var number_of_kyztlings = 10
var is_a_generator = true

func _ready() -> void:
	randomize()
	generate_kyztlings()
	
func generate_kyztlings() -> void:
	if is_a_generator:
		for i in range(number_of_kyztlings):
			var kyztling = load("res://Prefabs/Entities/Kyztling/kyztling.tscn").instance()
			kyztling.worship = self
			get_tree().get_meta("kyztling_container").add_child(kyztling)

# generate and return new point within max_wander_radius
# use even dist. algorithm from earlier?
func get_new_wander_point() -> Vector2:
	var wander_point = Vector2(max_wander_radius*sqrt(randf()), 0).rotated(2*PI*randf())
	
	return wander_point
