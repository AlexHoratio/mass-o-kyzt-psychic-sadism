extends Node

onready var softnoise_script = load("res://Scripts/softnoise.gd")
var softnoise

func _ready():
	softnoise = softnoise_script.SoftNoise.new()

func simple_noise2d(x, y=0):
	if y == 0:
		y = x + 1
		
	return softnoise.simple_noise2d(x, y)