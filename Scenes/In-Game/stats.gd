extends TextureButton

func _ready() -> void:
	pass

func _on_stats_pressed() -> void:
	pass # TODO: open beliefs menu

func _on_stats_mouse_entered() -> void:
	$hover.play("move_up")

func _on_stats_mouse_exited() -> void:
	$hover.play("move_down")