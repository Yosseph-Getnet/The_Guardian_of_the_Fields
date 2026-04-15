extends CharacterBody2D

const SPEED = 75.0
var hp: int = 3
var direction: int = 1

func _ready() -> void:
	# Walk inward towards the centre
	if global_position.x > 640:
		direction = -1
	else:
		direction = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 980 * delta
		
	velocity.x = direction * SPEED
	move_and_slide()

	# If it reached the crops
	if global_position.x > 440 and global_position.x < 840:
		var hm = get_tree().get_first_node_in_group("harvest_manager")
		if hm:
			hm.damage_crop(10.0)
		queue_free()

func take_damage(amount: int) -> void:
	hp -= amount
	
	# Damage flash
	var orig_modulate = $Sprite2D.modulate
	$Sprite2D.modulate = Color.WHITE
	await get_tree().create_timer(0.05).timeout
	if is_instance_valid(self):
		$Sprite2D.modulate = orig_modulate
		
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
		
		get_tree().current_scene.add_child(p)
		p.global_position = global_position
		get_tree().create_timer(1.0).timeout.connect(p.queue_free)
		
		queue_free()
