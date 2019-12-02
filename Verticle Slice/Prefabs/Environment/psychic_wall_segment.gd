extends Line2D

var time = 0
var offsets = []

var health = 100
var trauma = 0

var DRIFT_SPEED = 5
var MAX_SHAKE = 5

var UID = -1

func _ready() -> void:
	randomize()
	time = randf()*2*PI

func _process(delta: float) -> void:
	time += delta
	
	default_color.h = 0.8 + 0.1*sin(time)
	
	trauma = clamp(trauma - delta, 0, 1)
	position = Vector2((2*randf() - 1)*MAX_SHAKE, (2*randf() - 1)*MAX_SHAKE)*trauma*trauma

func destroy():
	get_node("destroy").play("destroy")

func _on_destroy_animation_finished(anim_name: String) -> void:
	if anim_name == "destroy":
		queue_free()
