extends "res://Verticle Slice/Prefabs/Vipers/ColonyViper.gd"

var target_located = false
var target_locked = false
var target = null

var ATTACK_RANGE = 200
var able_to_attack = true

func process_combat(delta):
	
	var closest_distance = 9999999
	var closest_kyztling = null
	
	if target_locked and not(target == null) and weakref(target).get_ref():
		closest_kyztling = target
	else:
		for kyztling in get_tree().get_nodes_in_group("ColonyKyztlings"):
			var distance = global_position.distance_to(kyztling.global_position) 
			
			if distance < closest_distance:
				closest_distance = distance
				closest_kyztling = kyztling
				
	$RayCast2D.cast_to = closest_kyztling.global_position - global_position 
	
	if $RayCast2D.get_collider() in get_tree().get_nodes_in_group("ColonyVipers"):
		$RayCast2D.add_exception($RayCast2D.get_collider())
	
	if closest_distance < ATTACK_RANGE and not($RayCast2D.get_collider() in get_tree().get_nodes_in_group("walls") or $RayCast2D.get_collider() in get_tree().get_nodes_in_group("wall_joints")):
		if able_to_attack:
			shoot_at_kyztling(closest_kyztling)
			
			if not(get_node("Sprite/head/shoot").is_playing()):
				get_node("Sprite/head/shoot").play("shoot")
	
	update()
		
func shoot_at_kyztling(kyztling):
	var homing_rocket = load("res://Verticle Slice/Prefabs/Bullets/homing_rocket.tscn").instance()
	homing_rocket.target_location = kyztling.global_position
	homing_rocket.global_position = global_position
	homing_rocket.parent = self
	
	get_parent().add_child(homing_rocket)
	
	able_to_attack = false
	$shoot_timer.start()
		
func _on_shoot_animation_finished(anim_name: String) -> void:
	if anim_name == "shoot":
		if target_located:
			get_node("Sprite/head/shoot").play("shoot")
		else: 
			get_node("Sprite/head").frame = 0

func _on_shoot_timer_timeout() -> void:
	able_to_attack = true
