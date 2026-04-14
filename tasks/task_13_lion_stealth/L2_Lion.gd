extends "res://Scripts/Core/Entity.gd"

signal lion_pounce_warning(position)
signal lion_pounced

const STEALTH_OPACITY = 0.3
const POUNCE_DISTANCE = 100
const WARNING_TIME = 1.5

var is_in_grass = false
var is_pouncing = false
var target_player = null

func _ready():
	modulate.a = 1.0
	add_to_group("lion") # ✅ FIXED HERE

func enter_grass():
	is_in_grass = true
	modulate.a = STEALTH_OPACITY

func exit_grass():
	is_in_grass = false
	modulate.a = 1.0

func set_target_player(player):
	target_player = player

func check_pounce():
	if is_pouncing:
		return
	
	if target_player and is_in_grass:
		var distance = global_position.distance_to(target_player.global_position)
		if distance < POUNCE_DISTANCE:
			start_pounce()

func start_pounce():
	is_pouncing = true
	
	emit_signal("lion_pounce_warning", global_position)
	await get_tree().create_timer(WARNING_TIME).timeout
	
	modulate.a = 1.0
	emit_signal("lion_pounced")
	
	is_pouncing = false

func _process(delta):
	check_pounce()
