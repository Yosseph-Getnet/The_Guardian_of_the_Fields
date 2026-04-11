extends ProgressBar

func _process(_delta):
	# This line looks for Amanuel's Heat Manager file in the game
	var heat_system = get_node_or_null("/root/L3_HeatManager")
	
	if heat_system:
		# This updates your bar to show the current heat level
		value = heat_system.current_heat
	else:
		# If the game hasn't started yet, the bar stays at 0
		value = 0
