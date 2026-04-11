extends Control

# --- STORY DATA ---
var opening_text = "The harvest is tomorrow, but the fields are under siege. Protect our lifeblood! If this field falls, the village starves."
var victory_text = "The Alpha Baboon is defeated! The village celebrates your courage. However, the victory is short-lived..."
var exodus_text = "A merchant speaks of dying herds in the Omo Valley. You pack your Wenchif and turn your gaze south. The journey begins."

# --- LOGIC ---
var current_step = 0 
var is_typing = false 
# This matches the folder in your second screenshot
var next_level_path = "res://Scenes/Levels/L2_Savannah.tscn" 

# --- REFERENCES (Updated to match your Scene Tree) ---
@onready var dialogue_box = $CanvasLayer/DialogueBox
@onready var text_label = $CanvasLayer/DialogueBox/RichTextLabel
@onready var next_arrow = $CanvasLayer/DialogueBox/NextArrow 

func _ready():
	dialogue_box.modulate.a = 0
	next_arrow.hide()
	start_narrative()

func start_narrative():
	dialogue_box.show()
	var tween = get_tree().create_tween()
	tween.tween_property(dialogue_box, "modulate:a", 1.0, 0.5)
	tween.finished.connect(func(): play_message(opening_text))

func play_message(full_text: String):
	is_typing = true
	next_arrow.hide()
	text_label.text = full_text
	text_label.visible_ratio = 0 
	var tween = get_tree().create_tween()
	tween.tween_property(text_label, "visible_ratio", 1.0, 3.0)
	tween.finished.connect(func(): 
		is_typing = false
		next_arrow.show()
	)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_typing:
			advance_story()

func advance_story():
	if current_step == 0:
		play_message(victory_text)
		current_step = 1
	elif current_step == 1:
		play_message(exodus_text)
		current_step = 2
	else:
		finish_level_1()

func finish_level_1():
	print("Level 1 Complete.")
	# SAFETY CHECK: Only change scene if the file actually exists
	if FileAccess.file_exists(next_level_path):
		get_tree().change_scene_to_file(next_level_path)
	else:
		# This prevents the RED ERROR in your screenshot
		print("ALERT: L2_Savannah.tscn not found in this project. Hiding UI instead.")
		dialogue_box.hide()
