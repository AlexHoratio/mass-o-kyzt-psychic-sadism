extends Area2D

var movement_vector = Vector2(1, 0)
var DAMAGE = 5

func _ready():
	rotation = movement_vector.angle()
	get_node("Particles2D").emitting = true
	
func _on_sniper_body_entered(body):
	if(body in get_tree().get_nodes_in_group("ColonyKyztlings")):
		body.damage(DAMAGE, movement_vector*35)

func _on_die_timeout():
	queue_free()

func _on_collision_expire_timeout() -> void:
	$CollisionShape2D.disabled = true
