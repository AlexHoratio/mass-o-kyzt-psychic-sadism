extends KinematicBody2D
class_name ColonyKyztling

var data

var following = false

var time = 0
var health = 50

var voice

var wander_speed = 10
var wander_point = Vector2(0, 0)
var wandering = true

var NOISE_OFFSET = 0
var SPEED = 10
var KNOCKBACK_FORCE = 2

var meta_vector = Vector2(0, 0)
var dash_vector = Vector2(0, 0)
var knockback_vector = Vector2(0, 0)
var damage_knockback_vector = Vector2(0, 0)

var able_to_shoot = true

func _ready():
	randomize()
	NOISE_OFFSET = randi()
	wander_speed += sin(2*PI*randf())*3
	wander_point = get_new_wander_point()#
	
	add_to_group("ColonyKyztlings")
	
	for kyztling in get_tree().get_nodes_in_group("ColonyKyztlings"):
		add_collision_exception_with(kyztling)
	
	voice = get_tree().get_meta("voice")
	add_collision_exception_with(voice)
	
	get_node("wandering/stop_wandering").wait_time = randf()*4
	
	time = randf()

func process_default_movements(delta):
	time += delta
	
	var movement_vector = Vector2(0, 0)
	
	if following:
		movement_vector += get_attraction_to_voice()
		
		if movement_vector.length() > 10:
			eval_sprite_hflip(movement_vector)
				
	elif wandering:
		movement_vector += get_wander()
		
		eval_sprite_hflip(movement_vector)
		
	movement_vector += get_attraction_from_kyztlings()
	
	if movement_vector.length() > 0.2:
		data.emit_signal("position_updated", movement_vector)
		
	knockback_vector *= 0.9
	damage_knockback_vector *= 0.9
		
	set_animation_from_speed(movement_vector.length())
	move_and_collide(damage_knockback_vector*delta*20 + knockback_vector*delta*35 + movement_vector*delta) # use move_and_slide instead?
	return position
		
func process_player_movements(delta):
	var MAX_META_VECTOR = 1
	var DASH_SPEED = 10
	var movement_vector = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_right"):
		movement_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		movement_vector.x -= 1
	if Input.is_action_pressed("ui_up"):
		movement_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement_vector.y += 1
	
	if movement_vector == Vector2(0, 0) and not($Sprite/shoot.is_playing()):
		get_node("Sprite").frame = 0
		get_node("Sprite/walk").stop()
	elif not(get_node("Sprite/walk").is_playing()) and not(get_node("Sprite/shoot").is_playing()):
		get_node("Sprite/walk").play("walk")
		
	if movement_vector != Vector2(0, 0):
		data.emit_signal("position_updated", movement_vector)
		
	eval_sprite_hflip(movement_vector)
		
	meta_vector.x = clamp(meta_vector.x + movement_vector.x, -MAX_META_VECTOR, MAX_META_VECTOR)
	meta_vector.y = clamp(meta_vector.y + movement_vector.y, -MAX_META_VECTOR, MAX_META_VECTOR)
	meta_vector *= 0.9
	
	if Input.is_action_just_pressed("dash"):
		dash_vector += movement_vector*DASH_SPEED
		
		var dash_effect = load("res://Verticle Slice/Prefabs/dash_effect.tscn").instance()
		add_child(dash_effect)
		
	dash_vector *= 0.9
	knockback_vector *= 0.9
	damage_knockback_vector *= 0.9
		
	move_and_collide((damage_knockback_vector + dash_vector + meta_vector + movement_vector.normalized())*delta*SPEED*2)
	return position
	
func eval_sprite_hflip(movement_vector):
	if not($Sprite/shoot.is_playing()): 
		if movement_vector.x < 0:
			set_sprite_hflip(true)
		elif movement_vector.x > 0:
			set_sprite_hflip(false)
			
func set_sprite_hflip(value):
	$Sprite.flip_h = value
	$Sprite/shadow.position.x = -1 if value else 1
		
func set_animation_from_speed(speed: float):
	if speed == 0:
		if not($Sprite/shoot.is_playing()):
			$Sprite.frame = 0
		$Sprite/walk.stop()
	else:
		if not($Sprite/walk.is_playing()) and not($Sprite/shoot.is_playing()):
			$Sprite/walk.play("walk")
		
		$Sprite/walk.playback_speed = clamp(4*(speed*1.2*0.01), 0, 4)
		
func get_attraction_to_voice() -> Vector2:
	var attraction = Vector2(0, 0)
	#var voice = get_tree().get_meta("voice")
	
	var distance_from_voice = position.distance_to(hive.get_voice().position)
	var speed = 1
	
	if distance_from_voice > 100:
		speed = distance_from_voice
	elif distance_from_voice > 20:
		speed = distance_from_voice/1.2
	elif distance_from_voice > 1:
		speed = -2*pow(distance_from_voice/20, -2)
	else:
		speed = 0
		
	attraction = Vector2(-speed, 0).rotated(position.angle_to_point(hive.get_voice().position))
	
	return attraction
	
func get_attraction_from_kyztlings() -> Vector2:
	var attraction = Vector2(0, 0)
	var repel_radius = 20
	
	for kyztling in get_tree().get_nodes_in_group("ColonyKyztlings"):
		if not(kyztling == self):
			var distance_from_kyztling = position.distance_to(kyztling.position)
			var speed = 1
			
			if distance_from_kyztling < repel_radius:
				speed = pow(distance_from_kyztling/repel_radius, -2)
			else:
				speed = 0
				
			if speed > 5:
				attraction += Vector2(speed, 0).rotated(position.angle_to_point(kyztling.position))
	
	return attraction
	
func get_wander():
	var wander_vector = Vector2(0, 0)
	
	wander_vector = wander_speed*Vector2(-1, 0).rotated(position.angle_to_point(wander_point))
	
	if position.distance_to(wander_point) < 5:
		wander_point = get_new_wander_point()
	
	return wander_vector
	
func get_new_wander_point():
	var wander_point = position + Vector2(50, 0).rotated(2*PI*randf())
	
	
	
	return wander_point
	
func start_following():
	following = true

func stop_following():
	following = false
	
func shoot_laser():
	if able_to_shoot:
		if hive.get_voice() == data:
			var laser = load("res://Verticle Slice/Prefabs/Bullets/player_laser.tscn").instance()
			laser.position = position + $bullet_origin.position
			laser.movement_vector = Vector2(-1, 0).rotated(global_position.angle_to_point(get_global_mouse_position()))
			get_node("..").add_child(laser)
			
			#player_muzzleflash()
			knockback_vector = -laser.movement_vector * KNOCKBACK_FORCE
			
			get_node("Sprite/walk").stop()
			get_node("Sprite/shoot").play("shoot")
				
			if get_global_mouse_position().x < global_position.x:
				set_sprite_hflip(true)
			elif get_global_mouse_position().x > global_position.x:
				set_sprite_hflip(false)
				
			able_to_shoot = false
			get_node("shoot_timer").start()
			
		elif randf() < 0.1:
			var laser = load("res://Verticle Slice/Prefabs/Bullets/ally_laser.tscn").instance()
			laser.position = position + $bullet_origin.position
			laser.movement_vector = Vector2(-1, 0).rotated(global_position.angle_to_point(get_global_mouse_position()))
			get_node("..").add_child(laser)
			
			knockback_vector = -laser.movement_vector * KNOCKBACK_FORCE
			
			get_node("Sprite/walk").stop()
			get_node("Sprite/shoot").play("shoot")
				
			if get_global_mouse_position().x < global_position.x:
				set_sprite_hflip(true)
			elif get_global_mouse_position().x > global_position.x:
				set_sprite_hflip(false)
				
			able_to_shoot = false
			get_node("shoot_timer").start()
		
func hit_by(object):
	if object.has_method("get_damage") and object.has_method("get_movement_vector"):
		damage(object.DAMAGE, Vector2(1, 0).rotated(object.movement_vector.angle()))
		
func damage(amount=0, knockback=Vector2(0, 0)):
	health -= amount
	damage_knockback_vector += knockback
	
	if health <= 0:
		kill()
		
func kill() -> void: # Someone killed this Viper! report to HQ!
	data.die() 
	
func die() -> void: # HQ said this body needs to die!
	queue_free()
		
func player_muzzleflash():
	var mf = load("res://Verticle Slice/Prefabs/Bullets/player_muzzleflash.tscn").instance()
	mf.position = Vector2(0, -2)
	add_child(mf)
	
func _on_wander_timeout():
	wandering = true
	get_node("wandering/stop_wandering").wait_time = 4 + sin(randf()*2*PI)*2
	get_node("wandering/stop_wandering").start()

func _on_stop_wandering_timeout():
	wandering = false
	get_node("wandering/wander").wait_time = 1 + sin(randf()*2*PI)*0.5
	get_node("wandering/wander").start()

func _on_shoot_timer_timeout() -> void:
	able_to_shoot = true
