extends Node2D

var movement_vector = Vector2(0, 0)
var speed = 100

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	position += movement_vector*delta*speed
	
	if position.x > 1010:
		die()
	if position.x < -50:
		die()
	if position.y > 590:
		die()
	if position.y < -50:
		die()
	
func generate_movement_vector_thru_screen_middle() -> void:
	movement_vector = Vector2(-1, 0).rotated(global_position.angle_to_point(Vector2(100, 0).rotated(2*randf()*PI) + Vector2(960, 540)/2))
	
	if movement_vector.x < 0:
		$Sprite.flip_h = true
		
func die():
	queue_free()
