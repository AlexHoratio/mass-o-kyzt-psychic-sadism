extends Sprite

var time = 0

func _ready() -> void:
	randomize()
	rotation = 2*PI*randf()
	
func _process(delta: float) -> void:
	time += delta
	
	self_modulate.h = 0.8 + 0.1*sin(time)