extends Node

# Find nodes (adjust paths if needed)
@onready var dust_storm = $"../DustStormSys"
@onready var activate_btn = $"../ActivateStorm"
@onready var deactivate_btn = $"../DeactivateStorm"

var controller

func _ready():
	print("========================================")
	print("S-15: TEST CONTROLLER STARTING")
	print("========================================")
	
	# Wait a moment
	await get_tree().process_frame
	
	# Find the dust storm controller
	if dust_storm:
		controller = dust_storm.get_node_or_null("DustStormController")
		if controller:
			print("✓ Found DustStormController!")
		else:
			print("✗ Could not find DustStormController inside DustStormSys")
	else:
		print("✗ Could not find DustStormSys node")
		print("  Make sure DustStormSys is a sibling of this node")
	
	# Connect buttons
	if activate_btn:
		activate_btn.pressed.connect(_on_activate_pressed)
		print("✓ Activate button connected")
		# Make sure button is visible
		activate_btn.visible = true
		activate_btn.disabled = false
	else:
		print("✗ Activate button not found - check node name")
		print("  Button should be named 'ActivateStorm'")
	
	if deactivate_btn:
		deactivate_btn.pressed.connect(_on_deactivate_pressed)
		print("✓ Deactivate button connected")
		deactivate_btn.visible = true
		deactivate_btn.disabled = false
	else:
		print("✗ Deactivate button not found - check node name")
		print("  Button should be named 'DeactivateStorm'")
	
	print("")
	print(">>> READY FOR TESTING <<<")
	print("Click 'Activate Storm' to see the dust storm!")
	print("========================================")

func _on_activate_pressed():
	print("")
	print("========================================")
	print("ACTIVATE BUTTON PRESSED!")
	print("========================================")
	
	if controller:
		controller.activate_storm(0.7)
	else:
		print("ERROR: No controller found!")
		print("Make sure DustStormController exists in the scene")

func _on_deactivate_pressed():
	print("")
	print("========================================")
	print("DEACTIVATE BUTTON PRESSED!")
	print("========================================")
	
	if controller:
		controller.deactivate_storm()
	else:
		print("ERROR: No controller found!")
