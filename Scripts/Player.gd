extends CharacterBody2D

const SPEED = 250.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var direction = 0.0
	
	# Sidestep movement
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction += 1.0
		
	if direction != 0:
		animated_sprite.flip_h = direction < 0
		animated_sprite.play("default")
	else:
		animated_sprite.stop()
		animated_sprite.frame = 0
	
	# Allow falling to ground
	if not is_on_floor():
		velocity.y += 980 * _delta
		
	velocity.x = direction * SPEED
	move_and_slide()
