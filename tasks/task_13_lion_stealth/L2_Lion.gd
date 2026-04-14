extends "res://Scripts/Core/Entity.gd"

signal lion_pounce_warning
signal lion_pounced

const STEALTH_OPACITY = 0.3
const POUNCE_DISTANCE = 100
const WARNING_TIME = 1.5
const PATROL_SPEED = 50
const PATROL_LEFT = 300
const PATROL_RIGHT = 700

var is_hidden = false
var is_pouncing = false
var target_player = null
var patrol_direction = 1

@onready var sprite = $AnimatedSprite2D
@onready var walk_animation = preload("res://tasks/task_13_lion_stealth/L2_Lion_Walk.tres")
@onready var pounce_animation = preload("res://tasks/task_13_lion_stealth/L2_Lion_Pounce.tres")

func _ready():
	print("LION: Script ready")
	add_to_group("lion")
	modulate.a = 1.0
	
	# Start with walk animation
	if walk_animation:
		sprite.sprite_frames = walk_animation
		sprite.play("walk")

func _physics_process(delta):
	# Patrol movement (only if not pouncing)
	if not is_pouncing:
		position.x += PATROL_SPEED * patrol_direction * delta
		
		if position.x >= PATROL_RIGHT:
			patrol_direction = -1
			if sprite:
				sprite.flip_h = true
		elif position.x <= PATROL_LEFT:
			patrol_direction = 1
			if sprite:
				sprite.flip_h = false
	
	# Check for pounce (only when hidden in grass)
	if target_player and is_hidden and not is_pouncing:
		var distance = global_position.distance_to(target_player.global_position)
		if distance < POUNCE_DISTANCE:
			start_pounce()

func set_target_player(player):
	target_player = player
	print("LION: Player target set")

# Called by grass
func set_opacity(value: float):
	if sprite:
		sprite.modulate.a = value
		is_hidden = (value < 1.0)
		print("LION: Opacity set to", value)

func start_pounce():
	if is_pouncing:
		return
	
	print("LION: Pounce sequence started")
	is_pouncing = true
	
	# Switch to pounce animation
	if pounce_animation:
		sprite.sprite_frames = pounce_animation
		sprite.play("pounce")
	
	# Emit warning signal
	emit_signal("lion_pounce_warning")
	print("LION: ⚠️ Warning signal emitted")
	
	# Wait 1.5 seconds
	await get_tree().create_timer(WARNING_TIME).timeout
	
	# Pounce!
	if sprite:
		sprite.modulate.a = 1.0
	emit_signal("lion_pounced")
	print("LION: 💥 Pounce signal emitted")
	
	# Switch back to walk animation
	if walk_animation:
		sprite.sprite_frames = walk_animation
		sprite.play("walk")
	
	is_pouncing = false
