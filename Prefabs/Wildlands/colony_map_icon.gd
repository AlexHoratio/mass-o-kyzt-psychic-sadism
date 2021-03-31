extends Node2D

var colony_population = 25
export var colony_id = 0 #default: random colony?

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()
	generate_citizens()
	set_info_panel()
	
func generate_citizens():
	for i in range(colony_population):
		var citizen = load("res://Prefabs/Wildlands/citizen.tscn").instance()
		citizen.roam_range = 100
		citizen.speed = 25
		citizen.static_target = position
		citizen.position = position
		get_node("../citizens").add_child(citizen)

func set_info_panel():
	get_node("info/population/number").text = str(colony_population)

func enter():
	#get_tree().change_scene("res://Scenes/In-Game/colony.tscn")
	spawn_menu()
	
func spawn_menu():
	var menu = load("res://Prefabs/Menu/colony_select_menu.tscn").instance()
	menu.target_colony = "res://Scenes/In-Game/Colonies/" + str(colony_id) + ".tscn"
	get_parent().add_child(menu)

func _on_Button_pressed() -> void:
	pass # Replace with function body.

func _on_Button_mouse_entered() -> void:
	$Sprite.material.set_shader_param("intensity", 32)
	$info.target_opacity = 1

func _on_Button_mouse_exited() -> void:
	$Sprite.material.set_shader_param("intensity", 0)
	$info.target_opacity = 0
