extends CharacterBody2D

func _ready():
	velocity = Vector2(400, 0)
	add_to_group("projectiles")

func _physics_process(delta):
	move_and_slide()
