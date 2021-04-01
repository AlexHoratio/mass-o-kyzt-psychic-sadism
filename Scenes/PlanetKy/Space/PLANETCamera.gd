extends Camera

var starter_transform 
var resetting_transform = false
var look_speed = 0.005
var move_speed = 0.1

var angle_theta = 0
var radius = 130
var orbit_speed = 0.2

var mouselook_enabled = false
var orbiting = true
var terrainscroll_mode = false
var terrainscroll_radius = 150
var terrainscroll_speed = 1
var landing = false


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	starter_transform = transform
	
#	radius = Vector2(transform.origin.x, transform.origin.z).length() overriding...
	angle_theta = Vector2(transform.origin.x, transform.origin.y).angle()

func _process(delta: float) -> void:
		
	if terrainscroll_mode:
		var movement_vector = Vector2(0, 0)
		
		if Input.is_action_pressed("w"):
			movement_vector.y -= 1
		if Input.is_action_pressed("s"):
			movement_vector.y += 1
		if Input.is_action_pressed("a"):
			movement_vector.x -= 1
		if Input.is_action_pressed("d"):
			movement_vector.x += 1
			
		terrainscroll_speed = (terrainscroll_radius - 46)/100.0
		
		transform = transform.rotated(Vector3(0, 1, 0), delta*movement_vector.x * max(terrainscroll_speed, 1.0))
		var new_vertical_transform = transform.rotated(transform.basis.x, delta*movement_vector.y * terrainscroll_speed)
		
		# Boundary check... no longer flickers horribly scrolling past poles
		if abs(new_vertical_transform.basis.get_euler().x * 180/PI) < 89:
			transform = new_vertical_transform
		transform = transform.looking_at(Vector3.ZERO, Vector3.UP)
		
		var hover_radius = transform.origin.length()
		var new_radius = lerp(hover_radius, terrainscroll_radius, 0.1)
		var proportion = new_radius/hover_radius
		transform.origin = transform.origin * proportion
		
	if orbiting:
		angle_theta += delta*orbit_speed
		
		var _2d_origin = Vector2(radius, 0).rotated(angle_theta)
		transform.origin = Vector3(_2d_origin.x, 0, _2d_origin.y) 
		
		var adjusted_target = Vector2(radius, 0).rotated(_2d_origin.angle_to_point(Vector2(0, 0)) + PI*1.0)
		transform = transform.looking_at(Vector3(adjusted_target.x, 0, adjusted_target.y), Vector3.UP)
		
		if landing:
			radius = lerp(radius, 151, 0.1)
			
			if abs(radius - 151) < 0.1:
				landing = false
				orbiting = false
				terrainscroll_mode = true
		
		if Input.is_action_just_pressed("lmb") && landing == false:
			landing = true
		
	if mouselook_enabled:
			
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
	if event is InputEventMouseMotion && mouselook_enabled:
		var mouse_look = Vector3(-event.relative.y, -event.relative.x, 0).normalized()
		rotate_object_local(mouse_look, event.relative.length() * look_speed)
		
	if event is InputEventMouseButton && terrainscroll_mode:
		if event.button_index == BUTTON_WHEEL_UP:
			terrainscroll_radius = max(51, 51 + ((terrainscroll_radius - 51) * 0.9))
		elif event.button_index == BUTTON_WHEEL_DOWN:
			terrainscroll_radius = min(151, terrainscroll_radius * 1.1)
