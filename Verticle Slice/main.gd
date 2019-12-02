extends Node2D

func _ready():
	$ColonyView.open()
	$PsychicView.close()
	get_colony_data()
	
func get_colony_data():
	pass # TODO: WRITE A FUNCTION THAT GENERATES A LEVEL FROM DATASET
		 # FOR NOW THIS DOES NOTHING! STATICALLY CREATED TEST LEVEL