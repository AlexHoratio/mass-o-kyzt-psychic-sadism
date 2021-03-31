extends Node2D

var time = 0
var amplitude = 50
var FADE_TIME = 2

const messages = [
	"You can do it!",
	"[Sine wave of enthusiasm]!",
	"[Tangent wave of hope]!",
	"[Cosine wave of determination]!",
	"We all believe in you!",
	"The Colony depends on you!",
	"Keep going!",
	"Thank you for fighting for us!",
	"Rejoice, don't fear! The Voice is here!",
]

func _ready() -> void:
	randomize()
	randomize_properties()
	randomize_message()

func _process(delta: float) -> void:
	time += delta
	
	$Label.rect_position.y -= amplitude*delta/time
	$Label.modulate.a = 1 if time < FADE_TIME else (1 - (time - FADE_TIME))
	
	if time > FADE_TIME + 1:
		queue_free()
	
func randomize_message() -> void:
	$Label.text = messages[randi()%messages.size()]
	$Label/shadow.text = $Label.text
	
func randomize_properties() -> void:
	amplitude = (0.6 + randf()*0.4)*amplitude
	$Label.rect_rotation = -5 + randf()*10
