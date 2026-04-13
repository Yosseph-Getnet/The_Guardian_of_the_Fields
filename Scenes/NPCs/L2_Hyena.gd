extendsres Base_Hazard

@export var speed: float = 110.0
@export var damage: int = 15
var phase_offset: float = 0.0

func _ready():
	# Per Brief S-12: Randomise phase so they don't move in unison
	phase_offset = randf_range(0, TAU)
	# Add to "hazard" group as required by Brief Page 3
	add_to_group("hazard")

func _physics_process(_delta):
	# 1. Find the nearest Zebu (Objective)
	var zebus = get_tree().get_nodes_in_group("objective")
	if zebus.is_empty(): return
	
	var target = zebus[0] # Simplest logic: target the first one
	var direction = (target.global_position - global_position).normalized()
	
	# 2. Zig-Zag Logic (Per Brief S-12)
	# Uses sine                                                                        wave to offset movement perpendicular to the target
	var side_way = Vector2(-direction.y, direction.x)
	var zig_zag = sin(Time.get_ticks_msec() * 0.002 + phase_offset)
	
	velocity = (direction + side_way * zig_zag).normalized() * speed
	move_and_slide()

# Triggered when Hyena touches Zebu
func _on_area_2d_body_entered(body):
	if body.is_in_group("objective"):
		if body.has_method("TakeDamage"):
			body.TakeDamage(damage)
			queue_free() # Hyena disappears after biting
