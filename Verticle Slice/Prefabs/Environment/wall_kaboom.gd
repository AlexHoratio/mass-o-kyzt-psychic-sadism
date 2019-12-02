extends Node2D

var start_point
var end_point

var WALL_WIDTH = 16
var length = 1

func _ready() -> void:
	generate_particle_emission_shape()
	$Particles2D.emitting = true
	
func generate_particle_emission_shape():
	var box = Vector3(length/2, WALL_WIDTH, 0)
	
	
	
	$Particles2D.process_material.emission_box_extents = box