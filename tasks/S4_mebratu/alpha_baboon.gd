extends CharacterBody2D

# Stats
@export var max_health: float = 100.0
var current_health: float = 100.0
@export var speed: float = 100.0
@export var detection_range: float = 500.0
@export var attack_range: float = 50.0

# States
enum State { IDLE, CHASE, ATTACK, ENRAGED }
var current_state = State.IDLE
var is_enraged: bool = false

@onready var sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player") 

func _physics_process(_delta):
	match current_state:
		State.IDLE:
			idle_state()
		State.CHASE:
			chase_state()
		State.ATTACK:
			attack_state()
		State.ENRAGED:
			enraged_state()

	move_and_slide()

func idle_state():
	sprite.play("idle")
	velocity = Vector2.ZERO
	if player and global_position.distance_to(player.global_position) < detection_range:
		current_state = State.CHASE

func chase_state():
	sprite.play("walk")
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		
		# Flip sprite based on direction
		sprite.flip_h = direction.x < 0
		
		if global_position.distance_to(player.global_position) < attack_range:
			current_state = State.ATTACK
		elif global_position.distance_to(player.global_position) > detection_range:
			current_state = State.IDLE

func attack_state():
	velocity = Vector2.ZERO
	sprite.play("attack")
	# Wait for animation to finish before chasing again
	if not sprite.is_playing():
		current_state = State.CHASE

func take_damage(amount: float):
	current_health -= amount
	check_health()

func check_health():
	if current_health <= (max_health * 0.3) and not is_enraged:
		enter_enraged_mode()

func enter_enraged_mode():
	is_enraged = true
	current_state = State.ENRAGED
	speed *= 1.5 
	sprite.speed_scale = 1.5 
	modulate = Color(1, 0.5, 0.5) 

func enraged_state():
	chase_state()

# === THE MISSING FUNCTION IS BELOW ===

func _on_hit_box_area_entered(area: Area2D) -> void:
	# This detects if the baboon's hitbox touches the player
	if area.is_in_group("player_hurtbox"):
		print("Alpha Baboon hit the player!")
		# You can add damage logic here later
#func _ready():
	#take_damage(75)
