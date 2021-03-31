extends Node
class_name ViperDataContainer

var number_of_vipers = 10

func _ready() -> void:
	generate_viper_datas()
	get_tree().set_meta("ViperDataContainer", self)
		
func generate_viper_datas():
	for hint in get_node("hints").get_children():
		number_of_vipers -= 1
		var viper = load("res://Verticle Slice/Prefabs/Vipers/ViperData.tscn").instance()
		
		viper.generate_self()
		viper.set_position(hint.global_position)
		
		add_child(viper)
		
	if number_of_vipers > 0:
		for i in range(number_of_vipers):
			var viper = load("res://Verticle Slice/Prefabs/Vipers/ViperData.tscn").instance()
			
			viper.generate_self()
	
			if get_node("../Attractors").get_children().size() > 0:
				var random_attractor = get_node("../Attractors").get_children()[randi()%get_node("../Attractors").get_children().size()]
				viper.set_position(Vector2(random_attractor.max_range, 0).rotated(2*PI*randf()) + random_attractor.position)
			else:
				viper.set_position(Vector2(480, 0) + get_random_onscreen_vector())
			
			add_child(viper)
		
func get_random_onscreen_vector() -> Vector2:
	return Vector2(randi()%480, randi()%270)