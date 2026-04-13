extends Area2D

func _ready():
	print("GRASS: Ready at position", position)

	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("GRASS: Body entered -", body.name)

	# Ignore player and others
	if not body.has_method("set_opacity"):
		return

	print("GRASS: Lion detected → hiding")
	body.set_opacity(0.3)

func _on_body_exited(body):
	print("GRASS: Body exited -", body.name)

	if not body.has_method("set_opacity"):
		return

	print("GRASS: Lion exited → visible")
	body.set_opacity(1.0)
