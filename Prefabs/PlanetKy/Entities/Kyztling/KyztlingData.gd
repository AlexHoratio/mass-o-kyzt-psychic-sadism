extends Node2D
class_name KyztlingData

signal position_updated # for altering ColonyKyztling's position when something
						#  happens in the psychic view

enum KYZTLING_TYPE {
	DEFAULT,
	INHIBITOR,
	VOICE,
}

const MAX_META_VECTOR = 1

var kyztling_type = KYZTLING_TYPE.DEFAULT

var colony_body: ColonyKyztling
var psychic_spirit: PsychicKyztling

var alive = true

func _ready():
	add_to_group("KyztlingDatas")
	randomize()
	#if kyztling_type == KYZTLING_TYPE.VOICE:
		#get_tree().set_meta("voice", self)
	
func generate_self(args={}):
	kyztling_type = KYZTLING_TYPE.DEFAULT if randf() > 0.1 else KYZTLING_TYPE.INHIBITOR
	
func set_voice(value):
	if value:
		kyztling_type = KYZTLING_TYPE.VOICE
	var camera = load("res://Verticle Slice/Prefabs/camera.tscn").instance()
	add_child(camera)
		
func _process(delta):
	if kyztling_type == KYZTLING_TYPE.VOICE:
		position = colony_body.process_player_movements(delta)
	elif kyztling_type == KYZTLING_TYPE.DEFAULT:
		position = colony_body.process_default_movements(delta)
		
	if Input.is_action_pressed("shoot"): #later use a timer for continuous shooting
		if hive.psychic_view_enabled:
			psychic_spirit.dispense_psychic_sybin()
		else:
			colony_body.shoot_laser()
		
func die() -> void:
	set_process(false)
	colony_body.die()
	psychic_spirit.die()
	
	if kyztling_type == KYZTLING_TYPE.VOICE:
		hive.select_new_voice()
	
	queue_free()