extends Node2D

# Manager Fix: Path points to the renamed Stone scene
@export var stone_scene: PackedScene = preload("res://Scenes/Player/StoneProjectile.tscn")

var charge_power: float = 0.0
var is_charging: bool = false
const MAX_CHARGE = 100.0

var player_node: Node2D

func _ready():
	player_node = get_tree().get_first_node_in_group("player")

func _process(delta):
	if is_instance_valid(player_node):
		# Smoothly follow the player node, hovering over their shoulder
		var target_pos = player_node.global_position + Vector2(-20, -40)
		if player_node.has_node("AnimatedSprite2D") and player_node.get_node("AnimatedSprite2D").flip_h:
			target_pos.x = player_node.global_position.x + 20
		global_position = global_position.lerp(target_pos, delta * 8.0)
		
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
