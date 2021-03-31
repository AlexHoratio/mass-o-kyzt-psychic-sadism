extends KinematicBody2D

var movement_vector = Vector2(0, 0)
var speed = 100#

func _ready() -> void:
	get_tree().set_meta("colony_voice", self)

func _process(delta: float) -> void:
	movement_vector = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_up"):
		movement_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		movement_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement_vector.x += 1
	
	move_and_collide(movement_vector*speed*delta)
	
	calculate_anim_from(movement_vector)
	
func calculate_anim_from(movement_vector: Vector2):
	if movement_vector.x < 0:
		$Sprite.flip_h = true
	if movement_vector.x > 0:
		$Sprite.flip_h = false
		
	if movement_vector.length() > 0:
		if not(get_node("Sprite/walk").is_playing()):
			get_node("Sprite/walk").play("walk")
	else:
		get_node("Sprite/walk").stop()
		get_node("Sprite").frame = 0
