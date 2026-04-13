extends PathFollow2D

@export var speed: float = 100.0

func _process(delta):
	progress += speed * delta
	if loop and progress_ratio >= 1.0:
		progress = 0.0
