extends PathFollow2D

@export var speed: float = 0.2
@export var bob_amplitude: float = 20.0
@export var bob_frequency: float = 8.0

var time_passed: float = 0.0

func _process(delta: float) -> void:
	# 1. Forward movement along the Path2D curve
	progress_ratio += speed * delta
	
	# Reset to start when it reaches the end
	if progress_ratio >= 1.0:
		progress_ratio = 0.0
		
	# 2. Local vertical swinging (bobbing)
	time_passed += delta
	# This moves the Vulture node relative to the PathFollow2D position
	$Vulture.position.y = sin(time_passed * bob_frequency) * bob_amplitude
