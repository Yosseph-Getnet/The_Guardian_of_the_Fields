extends CharacterBody2D

const SPEED = 160.0
var target_y: float = 620.0 # Teff crops altitude
var target_x: float = 640.0

func _ready() -> void:
    # Target somewhere in the field
    target_x = randf_range(440, 840)

func _physics_process(_delta: float) -> void:
    var dir = Vector2(target_x, target_y) - global_position
    
    if dir.length() > 5.0:
        velocity = dir.normalized() * SPEED
        move_and_slide()
    else:
        var hm = get_tree().get_first_node_in_group("harvest_manager")
        if hm:
            hm.damage_crop(5.0)
        queue_free()

func take_damage(_amount: int) -> void:
    # Feather burst particle effect without needing a separate scene
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
    
    get_tree().current_scene.add_child(particles)
    particles.global_position = global_position
    get_tree().create_timer(1.0).timeout.connect(particles.queue_free)
    
    queue_free()
