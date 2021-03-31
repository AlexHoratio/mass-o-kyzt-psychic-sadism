extends Area2D

var parent
 
var linear_velocity = Vector2(0, 0)
var torque = 0

func _ready() -> void:
	add_to_group("psychic_sybin")

func _process(delta: float) -> void:
	var region_start = Vector2(randi()%498, randi()%498)
	$Sprite.region_rect = Rect2(region_start, Vector2(2, 2))
			
	if linear_velocity.length() < 10:
		$Sprite.scale *= 0.9
		
	if $Sprite.scale.x < 0.1:
		queue_free()
		
	for kyztling in get_tree().get_nodes_in_group("PsychicKyztlings"):
		if position.distance_to(kyztling.position) < 100 and not(kyztling == parent):
			var pull_strength = pow(position.distance_to(kyztling.position), -1)*100
			linear_velocity += Vector2(-pull_strength, 0).rotated(position.angle_to_point(kyztling.position))
		
	if linear_velocity.length() > 100:
		linear_velocity = linear_velocity.normalized() * 100
		
	linear_velocity *= 0.98
		
	position += linear_velocity*delta
	rotation += torque
	
func apply_central_impulse(vector: Vector2):
	linear_velocity += vector
	
func apply_torque_impulse(amount: float):
	torque += amount

func _on_psychic_sybin_area_entered(area: Area2D) -> void:
	if area.get_parent() in get_tree().get_nodes_in_group("PsychicKyztlings") and not(area.get_parent() == parent):
		var kyztling = area.get_parent()
		kyztling.pickup_sybin()
		queue_free()
