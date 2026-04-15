extends CharacterBody2D

const SPEED = 200.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1.0
	if Input.is_action_pressed("move_left"):
		direction.x -= 1.0
	if Input.is_action_pressed("move_down"):
		direction.y += 1.0
	if Input.is_action_pressed("move_up"):
		direction.y -= 1.0
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
