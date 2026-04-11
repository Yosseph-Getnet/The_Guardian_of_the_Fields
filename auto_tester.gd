extends Node

func _ready():
	print("")
	print("╔════════════════════════════════════════╗")
	print("║     S-15 DUST STORM TEST               ║")
	print("║                                        ║")
	print("║  Storm will activate in 3 seconds...   ║")
	print("║  Look for golden-brown screen          ║")
	print("║  Look for floating dust particles      ║")
	print("╚════════════════════════════════════════╝")
	print("")
	
	await get_tree().create_timer(1.0).timeout
	
	var controller = get_node("../DustStormSystem/DustStormController")
	
	if controller:
		print("✓ Controller found!")
		print("")
		
		for i in range(3, 0, -1):
			print("Starting in ", i, "...")
			await get_tree().create_timer(1.0).timeout
		
		print("")
		print("🌪️ ACTIVATING SANDSTORM! 🌪️")
		controller.activate_storm(0.9)
		
		print("")
		print("Storm will rage for 6 seconds...")
		print("  - Screen should be golden-brown")
		print("  - Dust particles should float up")
		print("")
		
		await get_tree().create_timer(6.0).timeout
		
		print("🌤️ SANDSTORM SUBSIDING 🌤️")
		controller.deactivate_storm()
		
		print("")
		print("╔════════════════════════════════════════╗")
		print("║  TEST COMPLETE                         ║")
		print("║                                        ║")
		print("║  If you saw dark screen + particles:   ║")
		print("║         ✓ SUCCESS! ✓                   ║")
		print("╚════════════════════════════════════════╝")
	else:
		print("✗ ERROR: Controller not found!")
		print("  Make sure DustStormController exists!")
