extends CanvasLayer  # Root node type

# Reference the TextureRect node (the warning icon)
@onready var warning_icon = $WarningIcon

# This function runs when the scene is ready
func _ready():
	# Start with the warning icon hidden
	warning_icon.visible = false

# Function to show the warning icon
func show_warning():
	warning_icon.visible = true

# Function to hide the warning icon
func hide_warning():
	warning_icon.visible = false

# This function will be called when the lion is about to pounce
# "position" parameter can be used later to spawn particles at the correct location
func on_lion_pounce_warning(position: Vector2):
	show_warning()
	spawn_grass_particles(position)

	await get_tree().create_timer(1.5).timeout

	hide_warning()
func spawn_grass_particles(position: Vector2):
	var rustle_scene = preload("res://Scenes/Levels/GrassRustle.tscn")
	var rustle = rustle_scene.instantiate()
	
	rustle.position = position
	get_tree().current_scene.add_child(rustle)
	
	rustle.restart() # IMPORTANT FIX 
func _input(event):
	if event.is_action_pressed("ui_accept"):  # press Enter or Space
		$PounceWarning._on_lion_pounce_warning(Vector2(300,200))                   # add to the scene
