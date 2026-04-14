extends Node

# L3_Main.gd
# Attached to LevelController (Node) inside L3_Main.tscn
# Manages level state: reset, boss defeat, herd failure

func _ready() -> void:
	# Reset all level-scoped globals so a reload starts clean
	Global.herd_integrity = 100.0
	Global.player_thirst = 100.0
	Global.boss_enraged = false
	Global.current_ammo = 20

	# Find the boss using its group instead of a hardcoded path.
	# L3_ScavengerKing.gd must call add_to_group("boss") in its own _ready().
	var boss_nodes = get_tree().get_nodes_in_group("boss")
	if boss_nodes.size() > 0:
		var boss = boss_nodes[0]
		if boss.has_signal("boss_defeated"):
			boss.boss_defeated.connect(_on_boss_defeated)
		else:
			push_warning("L3_Main: boss node found but has no boss_defeated signal.")
	else:
		push_warning("L3_Main: no node in group 'boss' found at _ready().")


func _process(_delta: float) -> void:
	# Herd wipe condition — check every frame
	if Global.herd_integrity <= 0.0:
		_trigger_herd_failure()


func _on_boss_defeated() -> void:
	# Spawn epilogue scene at the scene root so it overlays everything
	var epilogue_scene = load("res://Scenes/UI/L3_Epilogue.tscn")
	if epilogue_scene:
		var epilogue = epilogue_scene.instantiate()
		get_tree().root.add_child(epilogue)
	else:
		push_warning("L3_Main: L3_Epilogue.tscn not found. Skipping epilogue.")


func _trigger_herd_failure() -> void:
	# Prevent multiple reloads firing in the same frame
	set_process(false)
	get_tree().reload_current_scene()
