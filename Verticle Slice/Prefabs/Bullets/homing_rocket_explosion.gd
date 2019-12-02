extends Node2D

func _ready() -> void:
	$Particles2D.emitting = true

func _on_Timer_timeout() -> void:
	queue_free()
