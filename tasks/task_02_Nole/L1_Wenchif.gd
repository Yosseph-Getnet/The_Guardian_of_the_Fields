extends Node2D

# Rule: Use PackedScene to load your Stone (S-2 Logic Requirement)
@export var stone_scene: PackedScene = preload("res://tasks/task_02_nole/Stone.tscn")

# S-2 Specifics: "Charge power variable clamped at 100"
var charge_power: float = 0.0
var is_charging: bool = false
const MAX_CHARGE = 100.0

func _ready():
	print("--- SLING SYSTEM INITIALIZED ---")
	$AnimatedSprite2D.play("idle")



func _process(delta):
	# Test if the script is even working
	if Engine.get_frames_drawn() % 60 == 0:
		print("Sling is active. Ammo: ", Global.current_ammo)

	look_at(get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if Global.current_ammo > 0:
			start_charging(delta)
	
	# Release check
	if is_charging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire()

func start_charging(delta):
	is_charging = true
	# Increase power over time, stopping at 100
	charge_power = min(charge_power + 150 * delta, MAX_CHARGE)
	$AnimatedSprite2D.play("charge")
	print("Charging... Power: ", int(charge_power))

func fire():
	is_charging = false
	
	# Rule: "Decrement Global.current_ammo by 1 per throw"
	Global.current_ammo -= 1
	
	# Create the stone instance
	var stone = stone_scene.instantiate()
	
	# Rule: Add to root so the stone doesn't move when the player moves
	get_tree().root.add_child(stone)
	
	# Start the stone at our "Muzzle" Marker2D position
	stone.global_position = $Muzzle.global_position
	
	# Calculate Direction
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	# Calculate Strength (Charge power affects how far it goes)
	var throw_strength = charge_power * 15.0 # Adjust 15.0 to make it feel "weighty"
	
	# Rule: "Apply a central impulse based on power and mouse direction"
	stone.apply_central_impulse(direction * throw_strength)
	
	# Play animation and reset
	$AnimatedSprite2D.play("attack")
	charge_power = 0.0
