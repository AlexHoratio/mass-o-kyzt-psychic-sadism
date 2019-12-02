extends Node2D

var end_point = Vector2(0, 0)

func _ready() -> void:
	$Line2D.add_point(end_point)
	var supersniper = load("res://Verticle Slice/Prefabs/Bullets/supersniper.tscn").instance()
	supersniper.movement_vector = end_point.normalized()
	add_child(supersniper)
	
func _process(delta: float) -> void:
	pass

func _on_Timer_timeout() -> void:
	queue_free()
