extends Node

var blur_coefficient: float = 0.0
var distortion_level: float = 1.0
var is_dust_triggered: bool = false

func apply_distortion_shader(terrain: Node):
	# Apply heat distortion shader to terrain
	print("Applying distortion shader to terrain")

func calculate_distance(hazard: Node) -> float:
	var player = get_node("/root/Player")
	return player.global_position.distance_to(hazard.global_position)

func apply_blur(hazard: Node, distance: float):
	blur_coefficient = clamp(distance / 100.0, 0.0, 1.0)
	print("Applying blur with coefficient %s to hazard" % blur_coefficient)

func disable_blur_and_distortion():
	print("Disabling blur and distortion effects")

func enable_haboob_effect(terrain: Node):
	is_dust_triggered = true
	print("Activating Haboob dust effect on terrain")
