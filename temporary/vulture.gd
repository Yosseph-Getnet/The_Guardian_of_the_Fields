extends CharacterBody2D

var is_swooping: bool = false
var target_position: Vector2
var target: Node2D   # <-- define the target here

@onready var anim = $AnimatedSprite2D
@onready var screech = $AudioStreamPlayer2D



func trigger_swoop(target_node: Node2D):
	is_swooping = true
	target = target_node              # <-- store the reference
	target_position = target.global_position
	anim.play("swoop")
	screech.play()

func _physics_process(delta):
	if is_swooping:
		var dir = (target_position - global_position).normalized()
		velocity = dir * 250.0
		move_and_slide()

		# Check if close enough to hit
		if global_position.distance_to(target_position) < 20.0:
			if target.has_method("take_damage"):
				target.take_damage(10)
			reset_to_path()

func reset_to_path():
	is_swooping = false
	anim.play("soar")
