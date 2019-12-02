extends KinematicBody2D
class_name ColonyViper

var wander_speed = 10
var wander_point = Vector2(0, 0)
var wandering = true

var data

var health = 100

func _ready() -> void:
	randomize()
	
	add_to_group("ColonyVipers")
	
	for viper in get_tree().get_nodes_in_group("ColonyVipers"):
		add_collision_exception_with(viper)
		
	wander_point = get_new_wander_point()
	
	get_node("Sprite").material = get_node("Sprite").material.duplicate()
	get_node("Sprite/head").material = get_node("Sprite").material

func process_movement(delta) -> Vector2:
	var movement_vector = Vector2(0, 0)
	
	if wandering:
		movement_vector += get_wander()
		
		if movement_vector.x < 0:
			get_node("Sprite").flip_h = false
		elif movement_vector.x > 0:
			get_node("Sprite").flip_h = true
	
	set_animation_from_speed(movement_vector.length())
	move_and_collide(movement_vector*delta)
	return position
	
func get_wander():
	var wander_vector = Vector2(0, 0)
	
	wander_vector = wander_speed*Vector2(-1, 0).rotated(position.angle_to_point(wander_point))
	
	if position.distance_to(wander_point) < 5:
		wander_point = get_new_wander_point()
	
	return wander_vector
	
func get_new_wander_point() -> Vector2:
	#fUCk you gdscript
	
	var wander_point = position + Vector2(50, 0).rotated(2*PI*randf())
	
	if get_tree().get_meta("attractors").get_viper_attractors().size() > 0:
		var attractor = get_tree().get_meta("attractors").get_viper_attractors()[randi()%get_tree().get_meta("attractors").get_viper_attractors().size()]
		wander_point = attractor.position + Vector2(attractor.max_range, 0).rotated(2*PI*randf())
		
	return wander_point
	
func set_animation_from_speed(speed: float) -> void:
	if speed == 0:
		$Sprite.frame = 0
		$Sprite/walk.stop()
	else:
		if not($Sprite/walk.is_playing()):
			$Sprite/walk.play("walk")
		
		$Sprite/walk.playback_speed = clamp(8*(speed*1.2*0.01), 0, 4)
		
func hit_by(object):
	if object.has_method("get_damage") and object.has_method("get_movement_vector"):
		damage(object.DAMAGE, Vector2(1, 0).rotated(object.movement_vector.angle()))
		
func kill() -> void: # Someone killed this Viper! report to HQ!
	data.die() 
	
func die() -> void: # HQ said this body needs to die!
	queue_free()

func damage(amount=0, knockback=Vector2(0, 0)) -> void:
	health -= amount
	if health <= 0:
		kill()
	
	get_node("Sprite").material.set_shader_param("enabled", true)
	get_node("hit_flash").start()

func _on_hit_flash_timeout() -> void:
	get_node("Sprite").material.set_shader_param("enabled", false)
	get_node("Sprite/head").material.set_shader_param("enabled", false)
