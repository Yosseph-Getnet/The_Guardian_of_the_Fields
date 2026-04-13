extends Node

var heat_level = 0

func _process(delta):

	heat_level += delta * 10

	if heat_level > 100:
		heat_level = 100
