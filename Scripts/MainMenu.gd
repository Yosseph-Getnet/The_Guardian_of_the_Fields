extends Control

@onready var start_button = $StartButton
@onready var title = $Title
@onready var instruction_panel = $InstructionPanel
@onready var proceed_button = $InstructionPanel/ProceedButton

func _ready() -> void:
	# Initial state: Title and Start button visible, Instructions hidden
	instruction_panel.visible = false
	start_button.pressed.connect(_on_start_pressed)
	proceed_button.pressed.connect(_on_proceed_pressed)

func _on_start_pressed() -> void:
	# Hide menu, show instructions
	title.visible = false
	start_button.visible = false
	instruction_panel.visible = true

func _on_proceed_pressed() -> void:
	# Load the First Level
	get_tree().change_scene_to_file("res://Scenes/Levels/L1_Highland.tscn")
