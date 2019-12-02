extends Node2D
class_name Colony

onready var data_container = get_tree().get_meta("KyztlingDataContainer")

func _ready():
	get_tree().set_meta("ColonyView", self)
	generate_colony_kyztlings()
	generate_colony_vipers()
	
func generate_colony_kyztlings() -> void:
	for KyztlingData in data_container.get_kyztlings():
		
		var ColonyKyztling = load("res://Verticle Slice/Prefabs/Kyztlings/ColonyKyztling.tscn").instance()
		ColonyKyztling.position = KyztlingData.position
		ColonyKyztling.data = KyztlingData
		KyztlingData.colony_body = ColonyKyztling
		$YSort.add_child(ColonyKyztling)
		
func generate_colony_vipers() -> void:
	for ViperData in get_tree().get_nodes_in_group("ViperDatas"):
		
		var ColonyViper = load("res://Verticle Slice/Prefabs/Vipers/ColonyViper.tscn").instance()
		ColonyViper.position = ViperData.position
		ColonyViper.data = ViperData
		ViperData.colony_body = ColonyViper
		$YSort.add_child(ColonyViper)
		
func open() -> void:
	get_node("YSort").visible = true
	get_node("../scenery").visible = true
	
	for item in get_node("debug").get_children():
		item.visible = true
		
	music_player.set_target_bus("colony_music")
	
	get_node("walls").visible = true
	
func close() -> void:
	get_node("YSort").visible = false
	get_node("../scenery").visible = false
	
	for item in get_node("debug").get_children():
		item.visible = false
		
	music_player.set_target_bus("web_music")
	
	get_node("walls").visible = false