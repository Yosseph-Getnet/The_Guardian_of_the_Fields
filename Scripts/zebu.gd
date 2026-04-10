extends CharacterBody2D

@export var speed: float = 6.0

func _physics_process(_delta: float) -> void:
	# Set velocity to move right (positive X direction)
	velocity.x = speed
	
	# move_and_slide handles the actual movement and physics
	move_and_slide()
