extends CharacterBody2D

# [cite: 62, 87] Signal registered in the Dependency Map
signal boss_enraged 

#  Using Master Vocabulary 'hazard_integrity' instead of 'health'
var hazard_integrity: float = 5.0 
var max_integrity: float = 5.0
var is_active: bool = true

func _ready():
	#  Adding to group "hazard" for S-3 compatibility
	add_to_group("hazard")

func take_damage(amount: float):
	hazard_integrity -= amount
	
	#  Trigger 'boss_enraged' signal at < 30% integrity
	if (hazard_integrity / max_integrity) < 0.3:
		emit_signal("boss_enraged")
	
	if hazard_integrity <= 0:
		die()

func die():
	is_active = false
	queue_free()

#  Signals are used to handle collision hits
func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("projectiles"):
		take_damage(1.0)
