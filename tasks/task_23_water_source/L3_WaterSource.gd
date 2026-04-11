extends Area2D

# S-23: Water Source - Afar Water Gourd
# Dependency D-15: Confirmed with S-20 Amanuel
# Variable: Global.player_thirst (float, 0-100)
# Action: Set to 100 on interact
# Sprites: glow (ready), empty (cooldown), base (fallback)

@onready var sprite: Sprite2D = $Sprite
@onready var cooldown_timer: Timer = $CooldownTimer

var is_available: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	_update_sprite()

func _on_body_entered(body: Node2D) -> void:
	if not is_available:
		return
	
	# Check if TheGuardian touched the water source
	if body.name == "TheGuardian" or body.is_in_group("Guardian"):
		_restore_thirst()

func _restore_thirst() -> void:
	# D-15: Reset thirst to 100 (S-20 Amanuel's variable)
	Global.player_thirst = 100.0
	
	# Start 30-second cooldown
	is_available = false
	cooldown_timer.start()
	_update_sprite()
	
	# Play drink sound if available
	if $DrinkSound:
		$DrinkSound.play()

func _on_cooldown_finished() -> void:
	is_available = true
	_update_sprite()

func _update_sprite() -> void:
	var base_path = "res://tasks/task_23_water_source/sprites/"
	
	# Load all three sprites
	var base_tex = load(base_path + "water_gourd_base.png")
	var glow_tex = load(base_path + "water_gourd_glow.png")
	var empty_tex = load(base_path + "water_gourd_empty.png")
	
	if is_available:
		# Use GLOW sprite if available, otherwise BASE as fallback
		sprite.texture = glow_tex if glow_tex else base_tex
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		# Use EMPTY sprite if available, otherwise BASE as fallback
		sprite.texture = empty_tex if empty_tex else base_tex
		sprite.modulate = Color(0.5, 0.5, 0.5, 1)
