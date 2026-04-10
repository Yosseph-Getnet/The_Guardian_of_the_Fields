extends Node

## S-15: Level 2 Integration Manager
## Connects Dust Storm with S-21's Habob Sandstorm system

var dust_storm_controller
var friendly_fire_detector

func _ready():
	# Find our systems
	dust_storm_controller = get_node("../DustStormController")
	friendly_fire_detector = get_node("../FriendlyFireDetector")
	
	print("S-15: Level 2 Integration Ready")
	
	# Wait for the main level to load
	await get_tree().process_frame
	connect_to_habob()

func connect_to_habob():
	# Find S-21's Habob system (L3_Habob.tscn)
	# This will be in the main level scene
	var habob = get_node("/root/Level2/Habob")  # Adjust path as needed
	
	if habob and habob.has_signal("storm_active"):
		habob.connect("storm_active", Callable(dust_storm_controller, "activate_storm"))
		print("S-15: Connected to S-21 Habob storm_active signal")
	else:
		print("S-15: Waiting for S-21 Habob system...")
		# Retry after 1 second
		await get_tree().create_timer(1.0).timeout
		connect_to_habob()

## Connect to arrow system (S-11's bow)
func connect_to_arrows():
	var arrow_system = get_node("/root/Level2/ArrowManager")
	if arrow_system:
		arrow_system.connect("arrow_hit", Callable(friendly_fire_detector, "on_arrow_hit"))
		print("S-15: Connected to S-11 arrow system")
