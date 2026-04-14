extends CharacterBody2D

@export var speed: float = 120.0
@export var attack_range: float = 40.0
@export var attack_cooldown: float = 1.5

var target: Node2D = null
var can_attack: bool = true

func _ready():
	# Find camel in scene (make sure camel is in "camel" group)
	target = get_tree().get_first_node_in_group("camel")

func _physics_process(delta):
	if target == null:
		return

	var direction = (target.global_position - global_position)
	var distance = direction.length()

	if distance > attack_range:
		# Move toward camel
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		# Stop and attack
		velocity = Vector2.ZERO
		move_and_slide()
		attack()

func attack():
	if not can_attack:
		return

	can_attack = false
	print("Vulture attacks camel!")

	# If camel has a damage function, call it
	if target.has_method("take_damage"):
		target.take_damage(10)

	# Cooldown timer
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
