extends Control

func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		follow_voice()
	else:
		stop_following()

func follow_voice():
	for kyztling in get_tree().get_nodes_in_group("ColonyKyztlings"):
		kyztling.start_following()
	
func stop_following():
	for kyztling in get_tree().get_nodes_in_group("ColonyKyztlings"):
		kyztling.stop_following()