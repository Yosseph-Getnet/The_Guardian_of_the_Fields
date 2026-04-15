extends Node2D

@onready var line = $Line2D
var is_charging: bool = false
var charge_start_pos: Vector2 = Vector2.ZERO
var max_drag_dist: float = 120.0

var projectile_scene = preload("res://Scenes/Player/StoneProjectile.tscn")

func _ready() -> void:
	# Disabled: The Wenchif throws the stones now!
	set_process(false)

func _process(_delta: float) -> void:

	# Charging mechanics: click anywhere, drag away from target to aim
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		if not is_charging:
			is_charging = true
			charge_start_pos = mouse_pos
		
		var drag_vector = charge_start_pos - mouse_pos
		if drag_vector.length() > max_drag_dist:
			drag_vector = drag_vector.normalized() * max_drag_dist
			
		line.points[0] = Vector2.ZERO
		# Visualize the band stretching back towards player's mouse gesture
		line.points[1] = -drag_vector 
	else:
		if is_charging:
			is_charging = false
			line.points[1] = Vector2.ZERO
			var drag_vector = charge_start_pos - get_global_mouse_position()
			
			# Fire threshold
			if drag_vector.length() > 20.0:
				if drag_vector.length() > max_drag_dist:
					drag_vector = drag_vector.normalized() * max_drag_dist
				shoot(drag_vector)

func shoot(drag_vector: Vector2) -> void:
	var player = get_parent()
	player.current_ammo -= 1
	
	var proj = projectile_scene.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = global_position
	
	# Fire in the dragged direction
	var impulse = drag_vector * 12.0 
	proj.linear_velocity = impulse
