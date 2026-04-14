extends "res://Scripts/Core/Objective.gd"
# --- References ---
@onready var path_follow = $Path2D/PathFollow2D
# This path is updated to find Area2D inside PathFollow2D
@onready var detection_area = $Path2D/PathFollow2D/Area2D

# --- Variables ---
var speed := 60.0
var is_blocked := false

func _ready():
	add_to_group("objective")
	
	if detection_area:
		# Ahmed's Point #3: Set the correct layer
		detection_area.collision_layer = 2
		detection_area.body_entered.connect(_on_body_entered)
		detection_area.body_exited.connect(_on_body_exited)

func _process(delta):
	# Ahmed's Point #9: Movement AND Goal Check must be inside this block
	if not is_blocked:
		path_follow.progress += speed * delta
		
		# Only check for the goal if we are actually moving
		if path_follow.progress_ratio >= 1.0:
			_on_reached_goal()

func _on_body_entered(body):
	if body.is_in_group("hazard") or body.is_in_group("player"):
		is_blocked = true

func _on_body_exited(body):
	if body.is_in_group("hazard") or body.is_in_group("player"):
		var bodies = detection_area.get_overlapping_bodies()
		var still_blocked = false
		for b in bodies:
			if b.is_in_group("hazard") or b.is_in_group("player"):
				still_blocked = true
				break
		is_blocked = still_blocked

func _on_reached_goal():
	# Safer check for the Global script
	if has_node("/root/Global"):
		get_node("/root/Global").herd_integrity += 20
	queue_free()
