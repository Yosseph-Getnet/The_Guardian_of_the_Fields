extends Node

# CORRECTED: Use proper node paths
@onready var activate_btn = $"../ActivateButton"
@onready var deactivate_btn = $"../DeactivateButton"
@onready var dust_storm = $"../DustStormSystem"

var controller

func _ready():
	# Find the dust storm controller
	if dust_storm:
		controller = dust_storm.get_node_or_null("DustStormController")
	
	# Connect buttons
	if activate_btn:
		activate_btn.pressed.connect(_on_activate_pressed)
		print("✓ Activate button connected")
	else:
		print("✗ Activate button not found - check node name")
	
	if deactivate_btn:
		deactivate_btn.pressed.connect(_on_deactivate_pressed)
		print("✓ Deactivate button connected")
	else:
		print("✗ Deactivate button not found - check node name")
	
	if controller:
		print("✓ Dust storm controller found!")
	else:
		print("✗ Controller not found!")

func _on_activate_pressed():
	print(">>> Activate button clicked!")
	if controller:
		controller.activate_storm(0.9)
	else:
		print("ERROR: Controller not found!")

func _on_deactivate_pressed():
	print(">>> Deactivate button clicked!")
	if controller:
		controller.deactivate_storm()
	else:
		print("ERROR: Controller not found!")
