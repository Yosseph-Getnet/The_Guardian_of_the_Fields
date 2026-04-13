extends CanvasLayer

# =========================
# UI REFERENCES
# =========================
@onready var warning_icon = $WarningIcon

# Runtime reference (DO NOT use @onready for group lookup)
var lion = null

# Prevent UI spam / overlapping warnings
var warning_active = false


# =========================
# READY
# =========================
func _ready():
	warning_icon.visible = false

	# Get lion safely AFTER scene is ready
	lion = get_tree().get_first_node_in_group("lion")

	if lion:
		lion.lion_pounce_warning.connect(on_lion_pounce_warning)
	else:
		push_error("Lion not found in scene tree!")


# =========================
# UI CONTROL
# =========================
func show_warning():
	warning_icon.visible = true


func hide_warning():
	warning_icon.visible = false


# =========================
# SIGNAL FROM LION
# =========================
func on_lion_pounce_warning(position: Vector2):
	# prevent overlapping warnings
	if warning_active:
		return

	warning_active = true

	show_warning()
	spawn_grass_particles(position)

	# Use lion's own timing (fallback to 1.5 if missing)
	var wait_time := 1.5
	if lion and lion.has_method("get_warning_time"):
		wait_time = lion.get_warning_time()

	await get_tree().create_timer(wait_time).timeout

	hide_warning()
	warning_active = false


# =========================
# GRASS RUSTLE EFFECT
# =========================
func spawn_grass_particles(position: Vector2):
	var rustle_scene = preload("res://Scenes/level2/GrassRustle.tscn")
	var rustle = rustle_scene.instantiate()

	rustle.global_position = position
	get_tree().current_scene.add_child(rustle)

	if rustle.has_method("restart"):
		rustle.restart()


# =========================
# DEBUG TEST (OPTIONAL)
# =========================
func _input(event):
	if event.is_action_pressed("ui_accept"):
		on_lion_pounce_warning(Vector2(300, 200))
