extends ProgressBar

func _process(delta):

	var heat_manager = get_node_or_null("/root/HeatManager")

	if heat_manager:
		value = heat_manager.heat_level
	else:
		value = 0
