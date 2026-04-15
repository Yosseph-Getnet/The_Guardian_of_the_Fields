extends Node2D

var bow_equipped = false
var bow_cooldown = true

var is_drawing := false
var draw_start_time := 0.0
var max_draw_time := 1.5

var arrow_count := 10

var arrow = preload("res://tasks/Scenes/arrow.tscn")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	if Input.is_action_just_pressed("equip or unequip bow"):
		bow_equipped = !bow_equipped
		print('bow state changed, E pressed')
	
	if Input.is_action_just_pressed("shoot_arrow") and bow_equipped and bow_cooldown:
		if has_atleast_one_arrow():
			if Global.cheka_active:
				fire_arrow(800.0)  # max strength (match your max_strength)
			else:
				is_drawing = true
				draw_start_time = Time.get_ticks_msec() / 1000.0
	
	if Input.is_action_just_released("shoot_arrow") and is_drawing and bow_equipped:
		is_drawing = false
		
		var draw_duration = measure_draw_duration()
		var strength = draw_duration_to_charge_strength(draw_duration)
		
		fire_arrow(strength)

func measure_draw_duration() -> float:
	var current_time = Time.get_ticks_msec() / 1000.0
	var duration = current_time - draw_start_time
	return clamp(duration, 0.0, max_draw_time)

func draw_duration_to_charge_strength(duration: float) -> float:
	var norm = duration / max_draw_time
	norm = clamp(norm, 0.0, 1.0)
	
	var min_strength = 200.0
	var max_strength = 800.0
	
	return min_strength + (max_strength - min_strength) * (norm * norm)
	
func calculate_damage(strength: float) -> float:
	var min_damage = 10.0
	var max_damage = 80.0
	
	var norm = strength / 800.0
	norm = clamp(norm, 0.0, 1.0)
	
	return min_damage + (max_damage - min_damage) * (norm * norm)

func fire_arrow(strength: float) -> void:
	bow_cooldown = false
	
	var arrow_instance = arrow.instantiate()
	arrow_instance.rotation = rotation
	
	arrow_instance.speed = strength
	arrow_instance.damage = calculate_damage(strength)
	
	get_tree().current_scene.add_child(arrow_instance)
	arrow_instance.global_position = $Marker2D.global_position
	
	$AudioStreamPlayer2D.play()
	
	consume_arrow()
	
	await get_tree().create_timer(0.4).timeout
	bow_cooldown = true

	print('Firing Arrow')

func has_atleast_one_arrow() -> bool:
	return arrow_count > 0

func consume_arrow() -> void:
	arrow_count -= 1
