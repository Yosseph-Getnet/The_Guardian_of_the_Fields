extends Area2D

@onready var buff_timer = $BuffTimer
var player_ref: CharacterBody2D = null

func _ready():
	# Connect signals to handle the logic flow
	body_entered.connect(_on_body_entered)
	buff_timer.timeout.connect(_on_buff_timer_timeout)

func _on_body_entered(body):
	# UC-L1-07: Verify if the object is the player
	if body.is_in_group("player") or body.name == "TheGuardian":
		player_ref = body
		activate_eagle_eye()

func activate_eagle_eye():
	# Line 21: Slow Hazards to 50% (Master Brief S-5)
	Engine.time_scale = 0.5
	
	# Line 24: Keep Guardian at 100% speed (Key Logic Item 8)
	if player_ref:
		player_ref.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Handle Audio Pitch (Issue #14)
	get_tree().call_group("audio", "set_pitch_scale", 0.5)
	
	# Start 10s countdown (Updated UC-L1-07 Requirements)
	buff_timer.start(10.0)
	
	# Visual Feedback
	$Sprite2D.hide()
	set_deferred("monitoring", false)

func _on_buff_timer_timeout():
	# Line 38: Normalize world speed
	Engine.time_scale = 1.0
	
	# Reset Audio and Player
	get_tree().call_group("audio", "set_pitch_scale", 1.0)
	if player_ref:
		player_ref.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Cleanup
	queue_free()
