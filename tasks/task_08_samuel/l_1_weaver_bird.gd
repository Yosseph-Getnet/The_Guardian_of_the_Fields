extends Area2D

# --- MOVEMENT VARIABLES ---
var horizontal_speed: float = 150.0
var wave_amplitude: float = 50.0   # How high/low the bird swoops
var wave_frequency: float = 5.0    # How fast it flaps up and down

var time_passed: float = 0.0
var start_y: float = 0.0

# --- COMBAT VARIABLES ---
var health: int = 1  # 1 hit from the wenchif will kill it

func _ready():
	# Remember exactly where the bird spawns so it waves around that baseline height
	start_y = position.y
	
	# Hacker bypass: Connect the collision signal through code instead of the glitchy UI
	area_entered.connect(_on_area_entered)

func _process(delta):
	# 1. Track the passing time to feed the math function
	time_passed += delta
	
	# 2. Move horizontally across the screen (Right to Left)
	position.x -= horizontal_speed * delta
	
	# 3. Apply the sine wave math for the continuous up-and-down flight pattern
	position.y = start_y + (sin(time_passed * wave_frequency) * wave_amplitude)

# --- COLLISION / ATTACKING ---
func _on_area_entered(area: Area2D):
	# Check if the object we collided with belongs to the "objective" group
	if area.is_in_group("objective"):
		# Subtract 5 points from the global health pool
		Global.herd_integrity -= 5.0
		
		# Destroy the bird so it doesn't drain the health infinitely
		queue_free()

# --- TAKING DAMAGE ---
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	# In the future, you could play a "poof" animation or feather particle effect here!
	queue_free() # Instantly delete the bird from the game
