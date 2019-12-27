extends Node2D

var static_target = Vector2(0, 0)

var movement_vector = Vector2(0, 0)
var target = Vector2(0, 0)

var roam_range = 15
var speed = 95

func _ready() -> void:
	randomize()
	target = position

func _process(delta: float) -> void:
	movement_vector = Vector2(0, 0)

	move_towards_target(delta)

	position += movement_vector

	if movement_vector.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

	#rotation += delta*(randf()*2 - 1)

func move_towards_target(delta):
	var step = Vector2(0, 0)

	if position.distance_to(target) > speed*delta:
		step = Vector2(-speed*delta, 0).rotated(position.angle_to_point(target))
	else:
		target = static_target + Vector2(randf()*roam_range, 0).rotated(randf()*2*PI)
		step = Vector2(-speed*delta, 0).rotated(position.angle_to_point(target))

	movement_vector += step