extends Node2D



func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if randi()%20 == 0:
		generate_runner()
		
func generate_runner() -> void:
	var runner = load("res://Prefabs/Menu/runner.tscn").instance()
	
	var spawnpoint = Vector2(0, 0)
	
	if randi()%2 == 0:
		if randi()%2 == 0:
			spawnpoint.x = -50
		else:
			spawnpoint.x = 1010
		spawnpoint.y = randf()*540
	else:
		if randi()%2 == 0:
			spawnpoint.y = -50
		else:
			spawnpoint.y = 590
		spawnpoint.x = randf()*960
		
	runner.position = spawnpoint
	
	runner.generate_movement_vector_thru_screen_middle()
	
	$runners.add_child(runner)
