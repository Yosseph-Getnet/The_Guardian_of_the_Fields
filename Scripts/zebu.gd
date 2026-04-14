extends CharacterBody2D

# Increase base speed; 6.0 is extremely slow for Godot pixels
@export var speed: float = 50.50 

func _ready() -> void:
	# 1. PHYSICAL SEPARATION: Shove each instance back by a random amount
	# so they don't start at the exact same X coordinate.
	position.x -= randf_range(50, 300)
	
	# 2. VISUAL VARIETY: Give them slightly different speeds
	# so the line stretches out as they walk.
	speed += randf_range(-20, 20)

func _physics_process(_delta: float) -> void:
	velocity.x = speed
	move_and_slide()
