extends CanvasLayer

@onready var ammo_label = $AmmoLabel
@onready var wave_label = $WaveLabel
@onready var health_bar = $HealthBar
@onready var game_over_label = $GameOverLabel

func update_ammo(current: int, maximum: int) -> void:
	if current <= 0:
		ammo_label.text = "Ammo: %d / %d\nReload at pile!" % [current, maximum]
		ammo_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2)) # Make it red
	else:
		ammo_label.text = "Ammo: %d / %d\n[E] at pile to reload!" % [current, maximum]
		ammo_label.remove_theme_color_override("font_color")

func update_wave(wave_num: int) -> void:
	wave_label.text = "Wave: %d" % wave_num

func update_health(health: float) -> void:
	health_bar.value = health

func show_game_over(win: bool) -> void:
	game_over_label.visible = true
	if win:
		game_over_label.text = "Crops Successfully Protected"
		game_over_label.add_theme_color_override("font_color", Color(0.2, 1.0, 0.2))
	else:
		game_over_label.text = "Crops Destroyed!\nGame Over"
		game_over_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
