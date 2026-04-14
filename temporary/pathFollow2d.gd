extends PathFollow2D

@export var loop_speed: float = 100.0
@onready var vulture = $Vulture

func _process(delta):
	if not vulture.is_swooping:
		offset += loop_speed * delta
		vulture.global_position = global_position
