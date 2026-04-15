extends "res://Scripts/Core/Entity.gd"

@export var lifetime: float = 20.0

var direction: Vector2 = Vector2.ZERO
var timer: float = 0.0

func _ready():
	add_to_group("hazard")

func _physics_process(delta):
	if direction == Vector2.ZERO:
		direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

	position += direction * speed * delta
	
	timer += delta
	if timer >= lifetime:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectiles"):
		
		var deflection = Vector2(
			randf_range(-1,1),
			randf_range(-1,1)
		).normalized() * 250   # STRONGER
		
		# FORCE new direction instead of weak addition
		body.velocity = body.velocity + deflection
		
		# CLAMP (REQUIRED)
		body.velocity = body.velocity.limit_length(300.0)

		print("DEFLECTED:", body.velocity)
