const Base_Hazard = preload("res://Scenes/Templates/Base_Hazard.tscn"
# Ta
var target_camel = null
var target_position = Vector2.ZERO

# Movement
var speed = 120.0
var flee_speed = 180.0

func _ready():
	super._ready()
	hurt_area.area_entered.connect(_on_hurt_area_entered)
	await get_tree().create_timer(0.5).timeout
	find_nearest_camel()

func _physics_process(delta):
	super._physics_process(delta)
	match current_state:
		State.HUNTING:
			hunting_behavior(delta)
		State.FLEEING:
			fleeing_behavior(delta)

func hunting_behavior(delta):
	if target_camel == null or not is_instance_valid(target_camel):
		find_nearest_camel()
		return
	target_position = target_camel.global_position
	nav_agent.target_position = target_position
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	if velocity.x != 0:
		sprite.scale.x = sign(velocity.x)

func fleeing_behavior(delta):
	flee_timer -= delta
	if flee_timer <= 0:
		current_state = State.HUNTING
		find_nearest_camel()
		return
	velocity = flee_direction * flee_speed
	move_and_slide()

func find_nearest_camel():
	var camels = get_tree().get_nodes_in_group("caravan_camels")
	if camels.is_empty():
		target_camel = null
		return
	var closest = null
	var closest_dist = INF
	for camel in camels:
		var dist = global_position.distance_to(camel.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = camel
	target_camel = closest

func _on_hurt_area_entered(area):
	if area.is_in_group("gile_dagger"):
		enter_flee_state()

func enter_flee_state():
	if current_state == State.FLEEING:
		return
	current_state = State.FLEEING
	flee_timer = 5.0
	var player = get_tree().get_first_node_in_group("player")
	if player:
		flee_direction = (global_position - player.global_position).normalized()
	if bark_sound and bark_sound.stream:
		bark_sound.pitch_scale = randf_range(0.8, 1.2)
		bark_sound.play()

func die():
	super.die()
	queue_free()
