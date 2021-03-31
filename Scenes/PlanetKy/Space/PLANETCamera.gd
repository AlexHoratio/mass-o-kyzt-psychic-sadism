extends Camera

var starter_transform 
var resetting_transform = false
var look_speed = 0.005
var move_speed = 0.1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	starter_transform = transform

func _process(delta: float) -> void:
	
	if resetting_transform:
		transform = transform.interpolate_with(starter_transform, delta * 2)
		
		if (transform.origin.distance_to(starter_transform.origin) < 0.1):
			resetting_transform = false
		
		return
		
	if Input.is_action_pressed("shift"):
		move_speed = 1
	else:
		move_speed = 0.1
		
	if Input.is_action_pressed("w"):
		var look_direction = transform.basis.get_euler()
		var translate_vec = Vector3(0, 0, -1).rotated(look_direction, PI)
		translate(translate_vec * move_speed)

	if Input.is_action_pressed("s"):
		var look_direction = transform.basis.get_euler()
		var translate_vec = Vector3(0, 0, 1).rotated(look_direction, PI)
		translate(translate_vec * move_speed)
		
	if Input.is_action_pressed("d"):
		var look_direction = transform.basis.get_euler()
		var translate_vec = Vector3(1, 0, 0).rotated(look_direction, PI)
		translate(translate_vec * move_speed)

	if Input.is_action_pressed("a"):
		var look_direction = transform.basis.get_euler()
		var translate_vec = Vector3(-1, 0, 0).rotated(look_direction, PI)
		translate(translate_vec * move_speed)

	if Input.is_action_pressed("spacebar"):
		var look_direction = transform.basis.get_euler()
		var translate_vec = Vector3(0, 1, 0).rotated(look_direction, PI)
		translate(translate_vec * move_speed)

	if Input.is_action_pressed("ctrl"):
		var look_direction = transform.basis.get_euler()
		var translate_vec = Vector3(0, -1, 0).rotated(look_direction, PI)
		translate(translate_vec * move_speed)
		
	if Input.is_action_just_pressed("l"):
		resetting_transform = true
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_look = Vector3(-event.relative.y, -event.relative.x, 0).normalized()
		rotate_object_local(mouse_look, event.relative.length() * look_speed)
