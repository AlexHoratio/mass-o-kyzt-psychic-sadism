extends Line2D

var ColonyWall
var PsychicWall

func _ready() -> void:
	pass

func segment_exploded(segment):
	PsychicWall.destroy_segment_by_uid(segment.UID)