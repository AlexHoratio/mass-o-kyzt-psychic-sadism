extends Node2D

func _ready():
	get_tree().set_meta("PsychicView", self)
	generate_psychic_kyztlings()
	generate_psychic_vipers()
	
func generate_psychic_kyztlings():
	for KyztlingData in get_tree().get_nodes_in_group("KyztlingDatas"):
		
		var PsychicKyztling = load("res://Verticle Slice/Prefabs/Kyztlings/PsychicKyztling.tscn").instance()
		PsychicKyztling.data = KyztlingData
		KyztlingData.psychic_spirit = PsychicKyztling
		get_node("YSort").add_child(PsychicKyztling)

func generate_psychic_vipers():
	for ViperData in get_tree().get_nodes_in_group("ViperDatas"):
		
		var PsychicViper = load("res://Verticle Slice/Prefabs/Vipers/PsychicViper.tscn").instance()
		PsychicViper.data = ViperData
		ViperData.psychic_spirit = PsychicViper
		get_node("YSort").add_child(PsychicViper)

func open():
	get_node("ParallaxBackground/ParallaxLayer").visible = true
	get_node("YSort").visible = true
	get_node("walls").visible = true
	
func close():
	get_node("ParallaxBackground/ParallaxLayer").visible = false
	get_node("YSort").visible = false
	get_node("walls").visible = false