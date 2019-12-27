extends Node2D

var mouse_normal = load("res://Verticle Slice/Graphics/GUI/Cursor/cursor_normal.png")
var mouse_down = load("res://Verticle Slice/Graphics/GUI/Cursor/cursor_down.png")

onready var canvas_layer = CanvasLayer.new()

func _ready() -> void:
	add_child(canvas_layer)

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT:
#			if event.is_pressed():
#				Input.set_custom_mouse_cursor(mouse_down, Input.CURSOR_ARROW, Vector2(56*0.25, 56))
#				var explosion = load("res://Verticle Slice/Prefabs/Utilities/mouse_px_fading.tscn").instance()
#				explosion.position = get_viewport().get_mouse_position() + Vector2(3.5, -7)
#				canvas_layer.add_child(explosion)
#			else:
#				Input.set_custom_mouse_cursor(mouse_normal, Input.CURSOR_ARROW, Vector2(56*0.25, 56))
				
