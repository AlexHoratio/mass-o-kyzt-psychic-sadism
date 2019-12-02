extends Node

var voice: KyztlingData = null
var psychic_view_enabled = false

func _ready() -> void:
	pass

func toggle_psychic_view() -> void:
	psychic_view_enabled = !psychic_view_enabled
	if psychic_view_enabled:
		open_psychic_view()
	else:
		open_colony_view()
	
func open_psychic_view() -> void:
	get_tree().get_meta("PsychicView").open()
	get_tree().get_meta("ColonyView").close()

func open_colony_view() -> void:
	get_tree().get_meta("ColonyView").open()
	get_tree().get_meta("PsychicView").close()

func get_voice() -> KyztlingData:
	if voice == null or not(weakref(voice).get_ref()):
		select_new_voice()
	return voice
	
func select_new_voice():
	for kyztling in get_tree().get_nodes_in_group("KyztlingDatas"):
		if weakref(kyztling).get_ref():
			kyztling.set_voice(true)
			voice = kyztling
			break