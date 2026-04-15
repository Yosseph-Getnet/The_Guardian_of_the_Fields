extends CharacterBody2D

# --- MOVEMENT VARIABLES ---
var speed: float = 160.0
var target_x: float = 640.0
var target_y: float = 620.0 # Teff crops altitude

# --- COMBAT VARIABLES ---
var health: int = 1  # 1 hit from the stone will kill it

func _ready():
	add_to_group("enemies") # essential for wave tracking
	
	# Target somewhere in the field
	target_x = randf_range(440, 840)
	
	# Make sure sprite faces correct direction (Left vs Right)
	if target_x < global_position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _physics_process(_delta):
	var dir = Vector2(target_x, target_y) - global_position
	
	if dir.length() > 5.0:
		velocity = dir.normalized() * speed
		move_and_slide()
	else:
		var hm = get_tree().get_first_node_in_group("harvest_manager")
		if hm:
			hm.damage_crop(5.0)
		queue_free()

# --- TAKING DAMAGE ---
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	# Play a "poof" feather particle effect
	var particles = CPUParticles2D.new()
	particles.emitting = true
	particles.one_shot = true
	particles.explosiveness = 0.9
	particles.amount = 15
	particles.lifetime = 0.4
	particles.spread = 180.0
	particles.initial_velocity_min = 40.0
	particles.initial_velocity_max = 90.0
	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 5.0
	particles.color = Color(0.9, 0.2, 0.2)
	
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.add_child(particles)
		particles.global_position = global_position
		get_tree().create_timer(1.0).timeout.connect(particles.queue_free)
	
	queue_free() # Instantly delete the bird from the game
