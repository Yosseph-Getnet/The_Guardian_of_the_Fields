extends Node

func _ready():
	print("=== AUTO TEST STARTED ===")
	
	# Wait for everything to load
	await get_tree().process_frame
	
	# Find the dust storm controller
	var dust_storm = get_node("../DustStormSys")
	var controller = dust_storm.get_node_or_null("DustStormController")
	
	if controller:
		print("✓ Controller found!")
		print("")
		print(">>> Sandstorm starting in 2 seconds...")
		
		await get_tree().create_timer(2.0).timeout
		
		controller.activate_storm(0.8)
		print(">>> SANDSTORM ACTIVE! Look for dark screen + particles")
		
		await get_tree().create_timer(5.0).timeout
		
		controller.deactivate_storm()
		print(">>> Sandstorm ended")
		print("")
		print("=== TEST COMPLETE ===")
	else:
		print("✗ Controller not found!")
		print("  Make sure DustStormController exists inside DustStormSys")
