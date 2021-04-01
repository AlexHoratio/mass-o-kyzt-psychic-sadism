extends Node2D
class_name ViperData

enum VIPER_TYPE {
	DEFAULT,
	WARBOT
}

var viper_type = VIPER_TYPE.WARBOT

var colony_body: ColonyViper
var psychic_spirit: PsychicViper

func _ready() -> void:
	add_to_group("ViperDatas")
	randomize()
	
func _process(delta: float) -> void:
	if viper_type in [VIPER_TYPE.DEFAULT, VIPER_TYPE.WARBOT]:
		position = colony_body.process_movement(delta)
	
	if viper_type == VIPER_TYPE.WARBOT:
		colony_body.process_combat(delta)
		
	
func generate_self() -> void:
	viper_type = VIPER_TYPE.WARBOT

func die() -> void:
	colony_body.die()
	psychic_spirit.die()
	queue_free()
