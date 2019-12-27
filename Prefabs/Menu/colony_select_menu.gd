extends CanvasLayer

var mouse_hovering = false

func _ready() -> void:
	get_tree().get_meta("wildlands_player").flag_inhibited = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and not(mouse_hovering):
		if not($AnimationPlayer.is_playing()):
			$AnimationPlayer.play("slide_out")

func _on_panel_mouse_entered() -> void:
	mouse_hovering = true

func _on_panel_mouse_exited() -> void:
	get_tree().get_meta("wildlands_player").flag_inhibited = true
	mouse_hovering = false
 
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "slide_out":
		get_tree().get_meta("wildlands_player").flag_inhibited = false
		queue_free()

func _on_visit_pressed() -> void:
	get_tree().change_scene("res://Scenes/In-Game/colony.tscn")
