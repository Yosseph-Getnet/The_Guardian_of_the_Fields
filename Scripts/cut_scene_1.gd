extends Panel

# Matching your exact node names from the screenshot
@onready var name_label = $VBoxContainer/Label
@onready var dialogue_label = $VBoxContainer/RichTextLabel

var dialogue_index = 0
var dialogue_list = [
	{
		"speaker": "Ato Tessema",
		"text": "The harvest is tomorrow, but the baboons and birds are relentless.\nLook at our Teff fields... they are in danger."
	},
	{
		"speaker": "Guardian",
		"text": "(Nods silently, looking at the golden field.)"
	},
	{
		"speaker": "Ato Tessema",
		"text": "Protect our lifeblood.\nIf this field falls, the village starves. I trust your aim, youth."
	},
	{
		"speaker": "Guardian",
		"text": "I will not let them touch a single grain, Ato Tessema."
	}
]

func _ready():
	# Start with the first line
	update_dialogue()

func _input(event):
	# Advance when you click or press Enter/Space
	if event.is_action_just_pressed("ui_accept") or event is InputEventMouseButton and event.pressed:
		dialogue_index += 1
		if dialogue_index < dialogue_list.size():
			update_dialogue()
		else:
			# Hide the panel when the conversation is over
			hide() 

func update_dialogue():
	var current = dialogue_list[dialogue_index]
	name_label.text = current["speaker"]
	dialogue_label.text = current["text"]
