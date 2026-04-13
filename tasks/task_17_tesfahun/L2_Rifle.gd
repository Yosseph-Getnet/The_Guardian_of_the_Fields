extends Node2D

# This tells other parts of the game (like the Boss) that they got hit
signal rifle_hit_boss

# These link the nodes we made in Step 1 to our code
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var reload_timer: Timer = $ReloadTimer

var is_sequencing: bool = false # Is the player currently waiting 3 seconds?

func _process(_delta):
	# If the player presses the "fire" button (you set this in Input Map)
	if Input.is_action_just_pressed("fire_rifle"):
		attempt_to_fire()

func attempt_to_fire():
	# Precondition: Must have ammo AND not be currently reloading
	if Global.rifle_ammo > 0 and not is_sequencing:
		print("Sequence started: Aiming for 3 seconds...")
		is_sequencing = true
		reload_timer.start() # Starts the 3.0s countdown
	elif Global.rifle_ammo <= 0:
		print("No ammo left!")

# We connect this function to the Timer's 'timeout' signal in the editor
func _on_reload_timer_timeout() -> void:
	is_sequencing = false
	Global.rifle_ammo -= 1 # Consume 1 bullet
	
	# FORCE THE RAYCAST TO UPDATE ITS MATH RIGHT NOW
	ray_cast.force_raycast_update()
	
	# Check if the "laser" is hitting anything
	if ray_cast.is_colliding():
		var hit_object = ray_cast.get_collider()
		
		# If the object hit is in the "Boss" group, tell the game!
		if hit_object.is_in_group("Boss"):
			rifle_hit_boss.emit()
			print("Direct hit on the Boss!")
