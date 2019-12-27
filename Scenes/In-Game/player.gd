extends KinematicBody2D

var next_waypoint = Vector2(0, 0)
var movement_vector = Vector2(0, 0)
var speed = 80

var flag_inhibited = false

signal expire_waypoints

func _ready() -> void:
	next_waypoint = position
	
	get_tree().set_meta("wildlands_player", self)
	generate_followers()

func _process(delta: float) -> void:
	movement_vector = Vector2(0, 0)
	
	move_to_waypoint(delta)
	
	move_and_collide(movement_vector)
	
	update_animations()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT and not(flag_inhibited):
			set_waypoint(get_global_mouse_position())
			
func generate_followers() -> void:
	for i in range(hive.army_size):
		var follower = load("res://Prefabs/Wildlands/tiny_follower.tscn").instance()
		follower.leader = self
		follower.position = position
		get_node("../followers").add_child(follower)

func set_waypoint(point: Vector2) -> void:
	next_waypoint = point
	
	emit_signal("expire_waypoints")
	
	var flag = load("res://Prefabs/Wildlands/flag.tscn").instance()
	flag.position = point
	flag.leader = self
	connect("expire_waypoints", flag, "die")
	get_parent().add_child(flag)
	
func move_to_waypoint(delta: float) -> void:
	var step = Vector2(0, 0)
	
	if position != next_waypoint:
		if position.distance_to(next_waypoint) > speed*delta:
			step = Vector2(-speed*delta, 0).rotated(position.angle_to_point(next_waypoint))
		else:
			step = Vector2(-position.distance_to(next_waypoint), 0).rotated(position.angle_to_point(next_waypoint))
			for colony in get_tree().get_nodes_in_group("colony_icons"):
				if colony.position.distance_to(position) < 64:
					colony.enter()
		
	movement_vector += step
	
func update_animations():
	var walk_animation = get_node("Sprite/walk")
	
	if next_waypoint.x < position.x:
		$Sprite.flip_h = true
	elif next_waypoint.x > position.x:
		$Sprite.flip_h = false
		
	if movement_vector.length() > 0:
		if not(walk_animation.is_playing()):
			walk_animation.play("walk")
	else:
		walk_animation.stop()
		$Sprite.frame = 0
		