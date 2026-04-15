extends Node2D

var current_wave: int = 1
var max_waves: int = 3
var enemies_to_spawn: int = 0
var spawn_timer: float = 0.0
var time_between_spawns: float = 2.0
var wave_active: bool = false
var game_over: bool = false

@onready var hud = $HUD
@onready var player = $Player
@onready var harvest_health = $HarvestHealth
@onready var spawns = $SpawnPoints.get_children()

var bird_scene = preload("res://Scenes/Enemies/L1_WeaverBird.tscn")
var baboon_scene = preload("res://Scenes/Enemies/L1_Baboon.tscn")

func _ready() -> void:
	start_wave(1)

func _process(delta: float) -> void:
	if game_over:
		return
		
	# Constant UI updates
	hud.update_ammo(Global.current_ammo, Global.max_ammo)
	hud.update_health(harvest_health.health)
	
	# Loss condition
	if harvest_health.is_dead():
		end_game(false)
		return

	# Wave progression logic
	if wave_active:
		if enemies_to_spawn > 0:
			spawn_timer -= delta
			if spawn_timer <= 0:
				spawn_enemy()
				spawn_timer = time_between_spawns
		elif get_tree().get_nodes_in_group("enemies").size() == 0:
			wave_active = false
			if current_wave < max_waves:
				current_wave += 1
				await get_tree().create_timer(3.0).timeout
				start_wave(current_wave)
			else:
				end_game(true)

func start_wave(wave_index: int) -> void:
	if game_over: return
	current_wave = wave_index
	hud.update_wave(current_wave)
	# Increase difficulty each wave
	enemies_to_spawn = 5 + (current_wave * 4) 
	time_between_spawns = max(0.8, 2.5 - (current_wave * 0.5))
	wave_active = true

func spawn_enemy() -> void:
	enemies_to_spawn -= 1
	var spawn_point = spawns.pick_random()
	var enemy = null
	
	# 70% bird, 30% baboon spawn rates
	if randf() < 0.7:
		enemy = bird_scene.instantiate()
		# Keep birds aerial if spawned lower
		if spawn_point.position.y > 400:
			enemy.position = Vector2(spawn_point.position.x, randf_range(100, 300))
		else:
			enemy.position = spawn_point.position
	else:
		enemy = baboon_scene.instantiate()
		# Make sure baboons spawn near the ground
		if spawn_point.global_position.x < 640:
			enemy.global_position = $SpawnPoints/BaboonSpawnL.global_position
		else:
			enemy.global_position = $SpawnPoints/BaboonSpawnR.global_position
			
	add_child(enemy)

func damage_crop(amount: float) -> void:
	if not game_over:
		harvest_health.take_damage(amount)
		# Visual hint that damage taken
		var tween = create_tween()
		tween.tween_property($Teff_Field, "modulate", Color(1, 0, 0), 0.1)
		tween.tween_property($Teff_Field, "modulate", Color.WHITE, 0.1)

func end_game(win: bool) -> void:
	game_over = true
	hud.show_game_over(win)
	get_tree().call_group("enemies", "queue_free")
