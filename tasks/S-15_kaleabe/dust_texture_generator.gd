extends Node

## S-15: Realistic Soft Dust Texture Generator

static func create_dust_texture() -> ImageTexture:
	# Create a 32x32 image (larger for smoother particles)
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	
	# Fill with transparent
	image.fill(Color.TRANSPARENT)
	
	# Create a soft, round dust particle
	var center = Vector2(16, 16)
	
	# Draw a soft circular gradient (like real dust)
	for x in range(32):
		for y in range(32):
			var pos = Vector2(x, y)
			var distance = center.distance_to(pos)
			
			# Soft circle with falloff
			if distance < 14:
				# Calculate softness (0 at edges, 1 at center)
				var softness = 1.0 - (distance / 14.0)
				softness = softness * softness  # Square for smoother falloff
				
				# Random variation for natural look
				var variation = 0.7 + (randf() * 0.6)
				var alpha = softness * 0.7 * variation
				
				# Warm desert sand colors
				var r = 0.75 + (randf() * 0.2)   # 0.75-0.95
				var g = 0.60 + (randf() * 0.15)  # 0.60-0.75
				var b = 0.40 + (randf() * 0.15)  # 0.40-0.55
				
				var color = Color(r, g, b, alpha)
				image.set_pixel(x, y, color)
	
	# Add some tiny specks for texture
	for i in range(80):
		var x = randi() % 32
		var y = randi() % 32
		var size = 1
		var alpha = 0.3 + (randf() * 0.4)
		var color = Color(0.85, 0.70, 0.50, alpha)
		
		for dx in range(-size, size + 1):
			for dy in range(-size, size + 1):
				var px = x + dx
				var py = y + dy
				if px >= 0 and px < 32 and py >= 0 and py < 32:
					var current = image.get_pixel(px, py)
					if current.a < alpha:
						image.set_pixel(px, py, color)
	
	# Create texture from image
	var texture = ImageTexture.create_from_image(image)
	
	# Note: In Godot 4, filtering is set on the CanvasItem, not on the texture
	# So we don't need set_filter() here
	
	return texture

func _ready():
	print("S-15: Realistic soft dust texture generator ready")
