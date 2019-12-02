extends Node
class_name KyztlingDataContainer

var number_of_kyztlings = 10

func _ready():
	generate_kyztling_datas()
	get_tree().set_meta("KyztlingDataContainer", self)

func generate_kyztling_datas():
	for hint in get_node("hints").get_children():
		number_of_kyztlings -= 1
		var kyztling = load("res://Verticle Slice/Prefabs/Kyztlings/KyztlingData.tscn").instance()
		
		kyztling.generate_self()
		kyztling.set_position(hint.global_position)
		
		add_child(kyztling)

	if number_of_kyztlings > 0:
		for i in range(number_of_kyztlings):
			var kyztling = load("res://Verticle Slice/Prefabs/Kyztlings/KyztlingData.tscn").instance()
	
			kyztling.generate_self()
			kyztling.set_position(get_random_onscreen_vector())
	
			add_child(kyztling)
		
	hive.select_new_voice()
		
#	var kyztling = load("res://Verticle Slice/Prefabs/Kyztlings/KyztlingData.tscn").instance()
#	kyztling.set_voice(true)
#	kyztling.set_position(Vector2(480, 270)/2)
#	add_child(kyztling)
	
func get_kyztlings() -> Array:
	return get_tree().get_nodes_in_group("KyztlingDatas")
	
func get_random_onscreen_vector() -> Vector2:
	return Vector2(randi()%480, randi()%270)