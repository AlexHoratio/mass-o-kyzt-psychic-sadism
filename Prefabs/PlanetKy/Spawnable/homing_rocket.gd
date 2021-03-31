extends Area2D

var target_location = Vector2(0, 0)
var movement_vector = Vector2(1, 0)

var speed = 100
var turn_speed = 100

var parent = null

var DAMAGE = 5

var dead = false

func _ready() -> void:
	randomize()
	assert(parent != null)
	movement_vector = Vector2(-speed, 0).rotated(global_position.angle_to_point(target_location) + (2*(randi()%2) - 1)*3*PI/4)

func _process(delta: float) -> void:
	position += movement_vector*delta

	movement_vector = movement_vector.linear_interpolate(Vector2(-speed, 0).rotated(global_position.angle_to_point(target_location)), 0.08)
	
#	if global_position.distance_to(target_location) < 5:
#		queue_free()

	if weakref(parent).get_ref() and not(parent == null):
		if global_position.distance_to(parent.global_position) > parent.global_position.distance_to(target_location):
			die()
	else:
		die()
		
func get_damage() -> int:
	return DAMAGE
	
func get_movement_vector() -> Vector2:
	return movement_vector
		
func die():
	var explosion = load("res://Verticle Slice/Prefabs/Bullets/homing_rocket_explosion.tscn").instance()
	explosion.global_position = global_position
	explosion.rotation = movement_vector.angle()
	get_parent().add_child(explosion)
		
	queue_free()

func _on_homing_rocket_body_entered(body: PhysicsBody2D) -> void:
	if not(dead) and body in get_tree().get_nodes_in_group("walls"):
		body.get_parent().damage(5)
		die()
		dead = true
