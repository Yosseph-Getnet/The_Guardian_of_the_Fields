extends Area2D

var is_player_resting: bool = false

# Quantified values from UC-L2-15
@export var integrity_multiplier: float = 2.0 
@export var stamina_multiplier: float = 3.0 

func _process(delta):
	# Requirement: Only apply bonus if player is resting AND in inter-wave state
	# Requirement: Check for environmental disruption (Sandstorms/Heat)
	if is_player_resting and Global.is_inter_wave and not Global.is_environmental_hazard_active:
		_apply_restoration(delta)

func _apply_restoration(delta):
	# Restore Integrity at 2x rate
	Global.guardian_integrity += Global.base_integrity_regen * integrity_multiplier * delta
	Global.guardian_integrity = clamp(Global.guardian_integrity, 0.0, 100.0)
	
	# Restore Stamina at 3x rate
	Global.player_stamina += Global.base_stamina_regen * stamina_multiplier * delta
	Global.player_stamina = clamp(Global.player_stamina, 0.0, 100.0)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Alternative Flow A4: Invalid Deployment check
		if Global.is_inter_wave:
			print("The Guardian is resting on the Borkoto!")
			is_player_resting = true
		else:
			print("Cannot rest during an active Hazard wave.")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Alternative Flow A3: Manual Interruption
		print("The Guardian has left the Borkoto.")
		is_player_resting = false
