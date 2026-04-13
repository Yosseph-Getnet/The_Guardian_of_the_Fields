extends Node2D

# Manager Fix: Path points to the renamed Stone scene
@export var stone_scene: PackedScene = preload("res://tasks/task_02_Nole/L1_Stone.tscn")

var charge_power: float = 0.0
var is_charging: bool = false
const MAX_CHARGE = 100.0

func _ready():
	# Temporary: Move sling to center so you can see it during testing
	# The manager can remove this or parent it to Nole later
	position = Vector2(576, 324)

func _process(delta):
	look_at(get_global_mouse_position())
	
	# Safe Ammo Check: If Global isn't loaded yet, assume we have ammo for testing
	var current_ammo = 1
	if is_instance_valid(get_node_or_null("/root/Global")):
		current_ammo = Global.current_ammo
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if current_ammo > 0:
			start_charging(delta)
			
	if is_charging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire()

func start_charging(delta):
	is_charging = true
	charge_power = min(charge_power + 150 * delta, MAX_CHARGE)
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("charge")

func fire():
	is_charging = false
	
	# Safe Ammo Decrement: Only subtract if Global exists
	if is_instance_valid(get_node_or_null("/root/Global")):
		Global.current_ammo -= 1
	
	var stone = stone_scene.instantiate()
	get_tree().root.add_child(stone)
	
	# Ensure the muzzle is correctly referenced
	if has_node("Muzzle"):
		stone.global_position = $Muzzle.global_position
	else:
		stone.global_position = global_position
	
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	# Apply force (Impulse)
	stone.apply_central_impulse(direction * (charge_power * 15.0 + 100.0))
	
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("attack")
	
	charge_power = 0.0
