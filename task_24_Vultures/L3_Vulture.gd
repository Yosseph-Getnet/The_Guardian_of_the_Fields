extends CharacterBody2D

var is_swooping: bool = false
var target_position: Vector2

@onready var anim = $AnimatedSprite2D
@onready var screech = $AudioStreamPlayer2D

func _ready():
	anim.play("soar")

# Example: trigger swoop manually with input
func _input(event):
	if event.is_action_pressed("attack"):
		trigger_swoop(Vector2(400, 200))  # example dive target

func trigger_swoop(pos: Vector2):
	is_swooping = true
	target_position = pos
	anim.play("swoop")
	screech.play()

func _physics_process(delta):
	if is_swooping:
		var dir = (target_position - global_position).normalized()
		velocity = dir * 250.0
		move_and_slide()

		if global_position.distance_to(target_position) < 20.0:
			reset_to_path()

func reset_to_path():
	is_swooping = false
	anim.play("soar")
