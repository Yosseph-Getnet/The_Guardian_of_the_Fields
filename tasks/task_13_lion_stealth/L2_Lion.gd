extends CharacterBody2D

@export var speed: float = 100.0
@export var roam_distance: float = 500.0   # how far it moves from grass

var direction := 1
var player = null
var is_hidden := false

var home_position: Vector2
var is_returning := false

# ✅ Pounce additions
signal lion_pounce_warning

var pounce_distance := 100.0
var pounce_delay := 1.5
var is_pouncing := false

func _ready():
	print("LION: Script ready")
	home_position = position

func _physics_process(_delta):
	var sprite = find_child("AnimatedSprite2D", true, false)

	# ✅ Pounce check (added)
	if player and not is_pouncing:
		if position.distance_to(player.position) < pounce_distance:
			start_pounce()

	if is_returning:
		# Move back to grass (home)
		var dir = (home_position - position).normalized()
		velocity = dir * speed

		# Flip sprite correctly
		if sprite:
			sprite.flip_h = dir.x < 0

		# Stop when close to home
		if position.distance_to(home_position) < 5:
			is_returning = false
			direction = 1
	else:
		# Normal movement away from grass
		velocity = Vector2(direction * speed, 0)

		# Flip sprite correctly
		if sprite:
			sprite.flip_h = direction < 0

		# Once far enough → return
		if abs(position.x - home_position.x) > roam_distance:
			is_returning = true

	move_and_slide()

# ✅ Pounce function (added)
func start_pounce():
	is_pouncing = true
	
	# Make lion fully visible
	set_opacity(1.0)
	
	# Emit warning signal
	emit_signal("lion_pounce_warning")
	print("LION: Pounce warning!")

	# Delay before actual pounce
	await get_tree().create_timer(pounce_delay).timeout
	
	print("LION: POUNCE!")
	
	# Simple pounce toward player
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed * 3   # faster burst
	
	is_pouncing = false

# Called from TestManager
func set_target_player(p):
	player = p
	print("LION: Player target set")

# Called from Grass
func set_opacity(value: float):
	var sprite = find_child("AnimatedSprite2D", true, false)
	if sprite:
		sprite.modulate.a = value
		is_hidden = value < 1.0
		print("LION: Opacity =", value)
	else:
		print("❌ LION: AnimatedSprite2D not found!")
