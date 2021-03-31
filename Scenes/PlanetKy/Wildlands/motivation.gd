extends TextureButton

# NOTE: THIS IS THE MOTIVATION BUTTON SCRIPT.

# DON'T BE FOOLED BY THE FACT IT SAYS STATS EVERYWHERE.

func _ready() -> void:
	pass

func _on_stats_pressed() -> void:
	var motivating_message = load("res://Prefabs/Entities/motivating_message.tscn").instance()
	motivating_message.position = rect_position + rect_size
	get_parent().add_child(motivating_message)

func _on_stats_mouse_entered() -> void:
	$hover.play("move_up")

func _on_stats_mouse_exited() -> void:
	$hover.play("move_down")
