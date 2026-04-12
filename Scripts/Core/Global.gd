extends Node

# --- GUARDIAN STATUS VARIABLES ---
# Initializing with standard float values for percentage-based bars
var guardian_integrity: float = 100.0
var player_stamina: float = 100.0

# --- BASE REGENERATION RATES ---
# These are the standard "per-second" recovery rates
var base_integrity_regen: float = 2.0
var base_stamina_regen: float = 5.0

# --- DIMOTFER RIFLE AMMUNITION ---
# [FIX] Added as per the "flags and notes" section of your task
var max_rifle_ammo: int = 3
var rifle_ammo: int = 3

# --- GAME STATE FLAGS ---
# Controls logic for UC-L2-15 (Resting) and environmental hazards
var is_inter_wave: bool = false
var is_environmental_hazard_active: bool = false

func _ready():
	# This will help you verify in the console that the Autoload is working
	print("System Initialization: Global Singleton is active.")
	print("Current Ammunition: ", rifle_ammo, "/", max_rifle_ammo)

# Optional: Function to reset stats at the start of a new level
func reset_level_stats():
	rifle_ammo = max_rifle_ammo
	player_stamina = 100.0
	guardian_integrity = 100.0
	is_inter_wave = false
