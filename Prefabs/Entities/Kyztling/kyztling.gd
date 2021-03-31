extends Area2D

var worship = null

# dict of bool values? or use an int and setting flags w/ an enumerator?
# dict of bools is more human-readable, this will never make a performance difference
var behaviour = {
	"wandering": true,
	"relaxed": true
}

var speed = 80

var wander_destination = Vector2(0, 0)

var movement_vector = Vector2(0, 0)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	movement_vector = Vector2(0, 0)
	
	if behaviour["wandering"]:
		movement_vector = Vector2(-1, 0).rotated(position.angle_to_point(wander_destination))
		evaluate_wander_destination(delta)
		
	set_anims_from_movement_vector(movement_vector)
		
	position += (movement_vector*speed*delta)
	
func evaluate_wander_destination(delta: float) -> void:
	if weakref(worship).get_ref():
		if position.distance_to(wander_destination) <= delta*speed:
			wander_destination = worship.get_new_wander_point()
		
func set_anims_from_movement_vector(movement_vector: Vector2) -> void:
	if movement_vector.x < 0:
		$Sprite.flip_h = true
	if movement_vector.x > 0:
		$Sprite.flip_h = false
		
	if movement_vector.length() > 0:
		if not(get_node("Sprite/walk").is_playing()):
			get_node("Sprite/walk").play("walk")
	else:
		get_node("Sprite/walk").stop()
		get_node("Sprite").frame = 0
