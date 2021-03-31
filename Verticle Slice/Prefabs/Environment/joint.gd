extends Sprite

func _ready() -> void:
	randomize()
	rotation = 2*PI*randf()
