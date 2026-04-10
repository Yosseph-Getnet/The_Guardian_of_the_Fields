extends Node

# SDD UC-L2-11: Friendly Fire on Herd
# Damage: 5% of herd integrity
# Score Penalty: -20 points (CONFIRM WITH MANAGER - Brief says -15)

const ZEBU_LAYER: int = 2  # D-10: Must match S-10's collision layer
const FRIENDLY_FIRE_SCORE_PENALTY: int = -20  # Per SDD (confirm with manager)
const HERD_INTEGRITY_DAMAGE_PERCENT: float = 0.05  # 5% damage

signal friendly_fire_triggered(zebu_node, damage_amount)

func _ready():
	print("========================================")
	print("S-15: FRIENDLY FIRE SYSTEM (SDD UC-L2-11)")
	print("Score Penalty: ", FRIENDLY_FIRE_SCORE_PENALTY)
	print("Herd Damage: ", HERD_INTEGRITY_DAMAGE_PERCENT * 100, "%")
	print("========================================")

func on_arrow_hit(hit_area: Area2D):
	# Check if we hit a Zebu (Layer 2 per D-10)
	if hit_area.collision_layer & (1 << (ZEBU_LAYER - 1)):
		handle_friendly_fire(hit_area)

func handle_friendly_fire(zebu: Area2D):
	print("⚠ SDD UC-L2-11: Friendly Fire on Zebu!")
	
	# 1. Apply damage to herd integrity (5% per SDD)
	var herd_integrity = get_herd_integrity()
	if herd_integrity:
		var damage = herd_integrity.max_value * HERD_INTEGRITY_DAMAGE_PERCENT
		herd_integrity.value -= damage
		print("✓ Herd integrity reduced by ", damage)
	
	# 2. Deduct score penalty (confirm amount with manager)
	var global = get_node_or_null("/root/Global")
	if global and "score" in global:
		global.score += FRIENDLY_FIRE_SCORE_PENALTY  # -20 per SDD
		print("✓ Score adjusted by ", FRIENDLY_FIRE_SCORE_PENALTY)
	
	# 3. Trigger flinch animation (SDD requirement)
	trigger_flinch_animation(zebu)
	
	# 4. Show penalty message (SDD requirement)
	show_friendly_fire_message()
	
	# 5. Red flash visual
	apply_red_flash(zebu)
	
	emit_signal("friendly_fire_triggered", zebu, abs(FRIENDLY_FIRE_SCORE_PENALTY))

func get_herd_integrity():
	# Find the herd integrity object (DefendableEntity per SDD)
	var global = get_node_or_null("/root/Global")
	if global and "herd_integrity" in global:
		return global.herd_integrity
	return null

func trigger_flinch_animation(zebu: Area2D):
	# SDD UC-L2-11: "Trigger flinch animation on the struck Zebu"
	var anim_player = zebu.get_node_or_null("AnimationPlayer")
	if anim_player:
		anim_player.play("flinch")
		print("✓ Zebu flinch animation triggered")

func show_friendly_fire_message():
	# SDD UC-L2-11: "Display penalty message 'Friendly Fire!'"
	print("⚠ Displaying: 'Friendly Fire!' (Red, 1.5 seconds)")
	# In actual game, this would call UI.ShowText()

func apply_red_flash(zebu: Area2D):
	var zebu_sprite = zebu.get_node_or_null("Sprite2D")
	if not zebu_sprite:
		for child in zebu.get_children():
			if child is Sprite2D:
				zebu_sprite = child
				break
	
	if zebu_sprite:
		var tween = create_tween()
		tween.tween_property(zebu_sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(zebu_sprite, "modulate", Color.WHITE, 0.2)
