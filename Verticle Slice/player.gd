extends KinematicBody2D

const MAX_META_VECTOR = 1

var SPEED = 50
var meta_vector = Vector2(0, 0)
#var swarm_size = 0

#func _ready():
#	get_tree().set_meta("voice", self)

#func _process(delta):
#	var movement_vector = Vector2(0, 0)
#
#	if Input.is_action_pressed("ui_right"):
#		movement_vector.x += 1
#	if Input.is_action_pressed("ui_left"):
#		movement_vector.x -= 1
#	if Input.is_action_pressed("ui_up"):
#		movement_vector.y -= 1
#	if Input.is_action_pressed("ui_down"):
#		movement_vector.y += 1
#
#	if movement_vector == Vector2(0, 0):
#		$Sprite.frame = 0
#		$Sprite/walk.stop()
#	elif not($Sprite/walk.is_playing()):
#		$Sprite/walk.play("walk")
#
#	if movement_vector.x < 0:
#		$Sprite.flip_h = true
#	elif movement_vector.x > 0:
#		$Sprite.flip_h = false
#
#	meta_vector.x = clamp(meta_vector.x + movement_vector.x, -MAX_META_VECTOR, MAX_META_VECTOR)
#	meta_vector.y = clamp(meta_vector.y + movement_vector.y, -MAX_META_VECTOR, MAX_META_VECTOR)
#	meta_vector *= 0.9
#
#	move_and_collide((meta_vector + movement_vector.normalized())*delta*SPEED)