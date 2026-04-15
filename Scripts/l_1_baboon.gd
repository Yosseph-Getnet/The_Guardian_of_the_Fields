extends CharacterBody2D

# --- VARIABLES ---
var speed: float = 100.0
var stagger_duration: float = 1.5
var is_carrying_teff: bool = false
var collision_detected: bool = false
var hp: int = 3 # Nole's stone does damage, so we need health!

var spawn_point: Vector2
var target_position: Vector2

# Grab our nodes
@onready var grunt_audio = $GruntAudio
@onready var anim_sprite = $AnimatedSprite2D

func _ready():
	# CONTRACT D-02: Add to hazard group for Ermias's Teff Field
	add_to_group("hazard")
	
	# S-3 REQUIREMENT: Randomize pitch so baboons sound different
	grunt_audio.pitch_scale = randf_range(0.8, 1.2)
	
	# Set up initial spawn
	spawn_point = global_position
	
	# Start walking!
	anim_sprite.play("walk")
	
	# --- ADD THIS MISSING LINE! ---
	add_to_group("enemies") # Required by GameManager to handle wave clearing
	target_position = Vector2(640, global_position.y)

func _physics_process(delta):
	# CONTRACT D-03: Listen for Mebratu's Alpha Boss Enrage state
	var current_speed = speed
	if Global.boss_enraged:
		current_speed *= 1.5
		anim_sprite.speed_scale = 1.5 # Animate faster!
	else:
		anim_sprite.speed_scale = 1.0
		
	# 1. STAGGER STATE (Hit by Wenchif)
	if collision_detected:
		if not is_on_floor():
			velocity.y += 980 * delta
		velocity.x = 0
		move_and_slide()
		return
		
	# 2. APPROACH / ESCAPE LOGIC
	if target_position != Vector2.ZERO:
		var direction_x = sign(target_position.x - global_position.x)
		
		velocity.x = direction_x * current_speed
		if not is_on_floor():
			velocity.y += 980 * delta
		move_and_slide()
		
		# Flip the sprite depending on which way we are walking
		if velocity.x < 0:
			anim_sprite.flip_h = true
		elif velocity.x > 0:
			anim_sprite.flip_h = false

		# If it reached the crops
		if global_position.x > 440 and global_position.x < 840:
			var hm = get_tree().get_first_node_in_group("harvest_manager")
			if hm:
				hm.damage_crop(10.0)
			queue_free()

# This function will be called by Ermias's Teff Field when we steal!
func steal_crop():
	is_carrying_teff = true
	target_position = spawn_point # Turn around and run away
	grunt_audio.play() # Grunt triumphantly!
	# Nole's Stone will call this function when it hits the baboon
	
func take_damage(amount: int):
	hp -= amount

	# If health drops to 0 or below, the baboon dies
	if hp <= 0:
		var p = CPUParticles2D.new()
		p.emitting = true
		p.one_shot = true
		p.explosiveness = 1.0
		p.amount = 20
		p.lifetime = 0.6
		p.spread = 180.0
		p.initial_velocity_min = 50.0
		p.initial_velocity_max = 100.0
		p.scale_amount_min = 3.0
		p.scale_amount_max = 6.0
		p.color = Color(0.5, 0.3, 0.1)
		
		var current_scene = get_tree().current_scene
		if current_scene:
			current_scene.add_child(p)
			p.global_position = global_position
			get_tree().create_timer(1.0).timeout.connect(p.queue_free)
			
		queue_free() 
		return
		
	# Trigger Stagger State (Pause movement)
	collision_detected = true
	anim_sprite.play("idle")

	# Wait for the stagger duration
	await get_tree().create_timer(stagger_duration).timeout

	# Resume walking!
	collision_detected = false
	anim_sprite.play("walk")
