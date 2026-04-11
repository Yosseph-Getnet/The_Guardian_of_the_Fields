extends GPUParticles2D

func _process(_delta):
	# Optimization script: 
	# If frames per second drop below 60, reduce particle count
	if Engine.get_frames_per_second() < 60:
		amount = 400
	else:
		amount = 1000