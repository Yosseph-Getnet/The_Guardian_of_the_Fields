extends "res://Scenes/Templates/Base_Objective.gd"

@onready var path_follow = $PathFollow2D
@onready var detection_area = $Area2D

var speed := 60.0
var is_blocked := false

func _ready():
	add_to_group("objective")
	
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _process(delta):
	if not is_blocked:
		path_follow.progress += speed * delta
	
	# Check if reached end of path
	if path_follow.progress_ratio >= 1.0:
		_on_reached_goal()

func _on_body_entered(body):
	if body.is_in_group("hazard"):
		is_blocked = true

func _on_body_exited(body):
	if body.is_in_group("hazard"):
		# Check if still overlapping others
		var bodies = detection_area.get_overlapping_bodies()
		for b in bodies:
			if b.is_in_group("hazard"):
				return
		is_blocked = false

func _on_reached_goal():
	Global.score += 20
	queue_free()
