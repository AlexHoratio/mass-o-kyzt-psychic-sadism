extends Node2D

var leader = null

var following_static_target = false
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
	
	if leader != null:
		move_towards_target(delta)
	
	position += movement_vector

	if movement_vector.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	#rotation += delta*(randf()*2 - 1)
	
func move_towards_target(delta):
	var step = Vector2(0, 0)
	
	if following_static_target:
		if position.distance_to(target) > speed*delta:
			step = Vector2(-speed*delta, 0).rotated(position.angle_to_point(target))
		else:
			target = static_target + Vector2(randf()*roam_range, 0).rotated(randf()*2*PI)
			step = Vector2(-speed*delta, 0).rotated(position.angle_to_point(target))
	else:
		if position.distance_to(leader.position) > 25:
			target = leader.position + Vector2(roam_range, 0).rotated(randf()*2*PI)
		
		if position.distance_to(target) > speed*delta:
			step = Vector2(-speed*delta, 0).rotated(position.angle_to_point(target))
		else:
			step = Vector2(-speed*delta, 0).rotated(position.angle_to_point(target))
			target = leader.position - Vector2(roam_range + 0.5*hive.army_size, 0).rotated(randf()*2*PI)
		
	movement_vector += step