extends Area2D

var movement_vector = Vector2(0, 0)
var SPEED = 250
var dead = false

var DAMAGE = 5

func _ready() -> void:
	add_to_group("ally_bullets")
	rotation = movement_vector.angle() + PI/2

func _process(delta: float) -> void:
	position += movement_vector*delta*SPEED

func _on_laser_body_entered(body: PhysicsBody2D) -> void:
#	if body in get_tree().get_nodes_in_group("ColonyVipers") and not(dead):
#		body.damage(5)
#		die()
#
#		dead = true
	
	if not(dead) and body in get_tree().get_nodes_in_group("walls"):
		body.get_parent().damage(5)
		die()
		dead = true
		
func get_damage() -> int:
	return DAMAGE
	
func get_movement_vector() -> Vector2:
	return movement_vector
	
func die() -> void:
	$Particles2D.emitting = false
	$Sprite.visible = false
	$Sprite2.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	var explosion = load("res://Verticle Slice/Prefabs/Bullets/player_muzzleflash.tscn").instance()
	add_child(explosion)
	
	var whoosh = load("res://Verticle Slice/Prefabs/Effects/whoosh.tscn").instance()
	add_child(whoosh)

	get_node("die").start()

func _on_die_timeout() -> void:
	queue_free()
