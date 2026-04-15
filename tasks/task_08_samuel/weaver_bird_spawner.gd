extends Node2D

# This tells the Spawner WHICH bird to clone
@export var bird_scene: PackedScene
@export var wave_interval: float = 4.0 # Sped up to 4 seconds so you don't fall asleep waiting!

@onready var wave_timer = $WaveTimer
@onready var swarm_audio = $SwarmAudio

func _ready():
	# Configure the timer to loop endlessly
	wave_timer.wait_time = wave_interval
	wave_timer.one_shot = false
	wave_timer.timeout.connect(_on_wave_timeout)
	wave_timer.start()
	
	# Start the audio perfectly silent
	swarm_audio.volume_db = -80.0
	swarm_audio.play()
	
	# Spawn the very first wave immediately
	spawn_wave()

func _on_wave_timeout():
	spawn_wave()

func spawn_wave():
	# Safety check in case the bird scene isn't loaded
	if bird_scene == null:
		return
		
	# CEO Requirement: Spawn 5 to 8 birds
	var bird_count = randi_range(5, 8)
	
	for i in range(bird_count):
		var bird = bird_scene.instantiate()
		
		# CRITICAL FIX: Set the position FIRST
		bird.position.y = randf_range(100.0, 500.0)
		bird.position.x = randf_range(1200.0, 1400.0)
		
		# ADD TO THE GAME SECOND
		add_child(bird)

	# Smoothly fade the audio IN 
	fade_audio(-10.0, 2.0)
	
	# Create a temporary timer to fade the audio OUT after the birds fly past
	get_tree().create_timer(3.0).timeout.connect(func(): fade_audio(-80.0, 2.0))

# Custom function to handle smooth audio fading using Godot's Tweens
func fade_audio(target_vol: float, duration: float):
	var tween = create_tween()
	tween.tween_property(swarm_audio, "volume_db", target_vol, duration)
