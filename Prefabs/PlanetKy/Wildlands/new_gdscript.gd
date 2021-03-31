extends Line2D

var time = 0
var offsets = []

var health = 100
var trauma = 0

var DRIFT_SPEED = 5
var MAX_SHAKE = 5

func _ready() -> void:
	randomize()
	for i in range(points.size()):
		offsets.append(Vector2(1, 0).rotated(2*randf()*PI))
		set_point_position(i, points[i] + offsets[i])

	generate_collision_shape()

func _process(delta: float) -> void:
	time += delta

	for i in range(points.size()):
		var original_loc = points[i] - offsets[i]
		#offsets[i] = offsets[i].rotated((randf()*delta)*DRIFT_SPEED)
		set_point_position(i, original_loc + offsets[i])

	$shadow.points = points

	trauma = clamp(trauma - delta, 0, 1)
	position = Vector2((2*randf() - 1)*MAX_SHAKE, (2*randf() - 1)*MAX_SHAKE)*trauma*trauma

func damage(amount=0):
	health -= amount
	trauma += 0.05*amount

	if health <= 0:
		explode()
		queue_free()

func explode():
	var wall_kaboom = load("res://Verticle Slice/Prefabs/Environment/wall_kaboom.tscn").instance()
	wall_kaboom.position = points[0].linear_interpolate(points[1], 0.5)
	wall_kaboom.rotation = points[0].angle_to_point(points[1])
	wall_kaboom.length = (points[0] - points[1]).length()
	get_parent().add_child(wall_kaboom)

func generate_collision_shape():
	var collision_polygon = PoolVector2Array()
	var WIDTH = 16

	# only one side
	for i in range(points.size() - 1, -1, -1): #find the normal of each point

		if not(i in [0, points.size() - 1]):
			var E = points[i - 1]
			var F = points[i]
			var G = points[i + 1]

			var EG = G - E
			var EF = F - E

			var GEF: float = EF.angle_to(EG)
			var VFE: float = 180 - 90 - GEF
			var VFX: float = F.angle_to_point(E) - VFE

			var V_ARROW: float = WIDTH#EF.length()*cos(VFE)

			var V = F + Vector2(V_ARROW, 0).rotated(VFX)

			collision_polygon.append(V) # do it by finding avg angle between adj. points, perpendicular at end points?

		elif i == 0:
			var E = points[points.size() - 2]
			var F = points[i]
			var G = points[i + 1]

			var EG = G - E
			var EF = F - E

			var GEF: float = EF.angle_to(EG)
			var VFE: float = 180 - 90 - GEF
			var VFX: float = F.angle_to_point(E) - VFE

			var V_ARROW: float = WIDTH#EF.length()*cos(VFE)

			var V = F + Vector2(V_ARROW, 0).rotated(VFX)

			collision_polygon.append(V) # do it by finding avg angle between adj. points, perpendicular at end points?
		elif i == points.size() - 1:
			var E = points[i - 1]
			var F = points[i]
			var G = points[0]

			var EG = G - E
			var EF = F - E

			var GEF: float = EF.angle_to(EG)
			var VFE: float = 180 - 90 - GEF
			var VFX: float = F.angle_to_point(E) - VFE

			var V_ARROW: float = WIDTH#EF.length()*cos(VFE)

			var V = F + Vector2(V_ARROW, 0).rotated(VFX)

			collision_polygon.append(V)

	WIDTH = -WIDTH
	for i in range(points.size()): #find the normal of each point

		if not(i in [0, points.size() - 1]):
			var E = points[i - 1]
			var F = points[i]
			var G = points[i + 1]

			var EG = G - E
			var EF = F - E

			var GEF: float = EF.angle_to(EG)
			var VFE: float = 180 - 90 - GEF
			var VFX: float = F.angle_to_point(E) - VFE

			var V_ARROW: float = WIDTH#EF.length()*cos(VFE)

			var V = F + Vector2(V_ARROW, 0).rotated(VFX)

			collision_polygon.append(V) # do it by finding avg angle between adj. points, perpendicular at end points?

		elif i == 0:
			var E = points[points.size() - 2]
			var F = points[i]
			var G = points[i + 1]

			var EG = G - E
			var EF = F - E

			var GEF: float = EF.angle_to(EG)
			var VFE: float = 180 - 90 - GEF
			var VFX: float = F.angle_to_point(E) - VFE

			var V_ARROW: float = WIDTH#EF.length()*cos(VFE)

			var V = F + Vector2(V_ARROW, 0).rotated(VFX)

			collision_polygon.append(V) # do it by finding avg angle between adj. points, perpendicular at end points?

		elif i == points.size() - 1:
			var E = points[i - 1]
			var F = points[i]
			var G = points[0]

			var EG = G - E
			var EF = F - E

			var GEF: float = EF.angle_to(EG)
			var VFE: float = 180 - 90 - GEF
			var VFX: float = F.angle_to_point(E) - VFE

			var V_ARROW: float = WIDTH#EF.length()*cos(VFE)

			var V = F + Vector2(V_ARROW, 0).rotated(VFX)

			collision_polygon.append(V)

	$StaticBody2D/CollisionPolygon2D.set_polygon(collision_polygon)
