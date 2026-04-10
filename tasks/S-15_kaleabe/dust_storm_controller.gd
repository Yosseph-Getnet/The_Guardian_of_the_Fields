extends Node

# SDD UC-L2-12: Boss Event - Dust Storm Ambush
# Trigger: 90% progress reached
# Visibility: 20% during storm
# Duration: Until 3 lions are eliminated

@onready var canvas_modulate = get_node("../CanvasModulate")
@onready var dust_particles = get_node("../DustParticles")
@onready var dust_particles2 = get_node_or_null("../DustParticles2")
@onready var dust_particles3 = get_node_or_null("../DustParticles3")
@onready var dust_particles4 = get_node_or_null("../DustParticles4")
@onready var dust_particles5 = get_node_or_null("../DustParticles5")

var is_storm_active: bool = false
var storm_intensity: float = 0.0
var boss_event_active: bool = false

signal storm_active(is_active: bool)
signal boss_ambush_started()
signal boss_ambush_ended()

func _ready():
	print("========================================")
	print("S-15: DUST STORM SYSTEM (SDD UC-L2-12)")
	print("Boss Event: Dust Storm Ambush")
	print("Visibility during storm: 20%")
	print("========================================")
	
	if canvas_modulate:
		canvas_modulate.visible = false
	
	var dust_texture = create_yellowish_dust_texture()
	
	create_dust_emitter("DustParticles", 600, -250, dust_texture)
	create_dust_emitter("DustParticles2", 600, -125, dust_texture)
	create_dust_emitter("DustParticles3", 600, 0, dust_texture)
	create_dust_emitter("DustParticles4", 600, 125, dust_texture)
	create_dust_emitter("DustParticles5", 600, 250, dust_texture)
	
	print("✓ 5 dust emitters ready for boss ambush")

# SDD UC-L2-12: Called when 90% progress reached
func trigger_boss_ambush():
	print("")
	print("========================================")
	print("🔥 SDD UC-L2-12: BOSS EVENT TRIGGERED! 🔥")
	print("90% Progress Reached - Dust Storm Ambush!")
	print("========================================")
	
	boss_event_active = true
	activate_storm(0.9)  # Full intensity
	
	# Emit signal that boss ambush started (for other systems)
	emit_signal("boss_ambush_started")
	print("✓ 3 lions will spawn (North, East, West)")

# SDD UC-L2-12: Called when all 3 lions are eliminated
func end_boss_ambush():
	print("")
	print("========================================")
	print("🏆 SDD UC-L2-12: BOSS EVENT COMPLETE! 🏆")
	print("All 3 lions eliminated - Dust storm clearing")
	print("========================================")
	
	deactivate_storm()
	boss_event_active = false
	emit_signal("boss_ambush_ended")

func create_yellowish_dust_texture():
	"""Create soft, yellowish/brown dust particle texture"""
	var image = Image.create(8, 8, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	var dust_colors = [
		Color(0.95, 0.85, 0.65, 1.0),
		Color(0.85, 0.75, 0.55, 1.0),
		Color(0.75, 0.65, 0.45, 1.0),
	]
	
	var center = Vector2(4, 4)
	for x in range(8):
		for y in range(8):
			var distance = center.distance_to(Vector2(x, y))
			if distance < 3.5:
				var alpha = 1.0 - (distance / 3.5)
				alpha = alpha * alpha * 0.8
				var color = dust_colors[randi() % dust_colors.size()]
				color.a = alpha
				image.set_pixel(x, y, color)
	
	return ImageTexture.create_from_image(image)

func create_dust_emitter(name, pos_x, pos_y, texture):
	var emitter = get_node_or_null("../" + name)
	
	if not emitter:
		emitter = GPUParticles2D.new()
		emitter.name = name
		get_parent().add_child(emitter)
	
	emitter.position = Vector2(pos_x, pos_y)
	emitter.texture = texture
	emitter.emitting = false
	emitter.amount = 600
	emitter.lifetime = 2.5
	emitter.one_shot = false
	emitter.explosiveness = 0.0
	emitter.randomness = 0.9
	emitter.fixed_fps = 30
	
	var material = ParticleProcessMaterial.new()
	material.direction = Vector3(0, -1, 0)
	material.spread = 180.0
	material.flatness = 0.5
	material.gravity = Vector3(0, 5, 0)
	material.initial_velocity_min = 10.0
	material.initial_velocity_max = 40.0
	material.angular_velocity_min = -20.0
	material.angular_velocity_max = 20.0
	material.scale_min = 0.08
	material.scale_max = 0.15
	
	var gradient = Gradient.new()
	gradient.set_color(0, Color(0.95, 0.85, 0.65, 0.9))
	gradient.set_color(0.5, Color(0.85, 0.75, 0.55, 0.5))
	gradient.set_color(1.0, Color(0.75, 0.65, 0.45, 0.0))
	
	var color_ramp = GradientTexture1D.new()
	color_ramp.gradient = gradient
	material.color_ramp = color_ramp
	
	emitter.process_material = material

func activate_storm(intensity: float = 0.9):
	print("🌪️ DUST STORM ACTIVATED (SDD UC-L2-12)")
	
	is_storm_active = true
	storm_intensity = clamp(intensity, 0.5, 1.0)
	
	if canvas_modulate:
		canvas_modulate.visible = true
		# SDD UC-L2-12: Visibility set to 20%
		canvas_modulate.color = Color(0.75, 0.62, 0.48, 0.2)
		print("✓ Screen visibility reduced to 20% per SDD")
	
	var emitters = ["DustParticles", "DustParticles2", "DustParticles3", "DustParticles4", "DustParticles5"]
	
	for name in emitters:
		var emitter = get_node_or_null("../" + name)
		if emitter:
			emitter.emitting = true
			emitter.amount = int(600 * storm_intensity)
			emitter.restart()
	
	emit_signal("storm_active", true)

func deactivate_storm():
	print("🌤️ DUST STORM CLEARING")
	
	is_storm_active = false
	storm_intensity = 0.0
	
	if canvas_modulate:
		canvas_modulate.visible = false
	
	var emitters = ["DustParticles", "DustParticles2", "DustParticles3", "DustParticles4", "DustParticles5"]
	
	for name in emitters:
		var emitter = get_node_or_null("../" + name)
		if emitter:
			emitter.emitting = false
	
	emit_signal("storm_active", false)
