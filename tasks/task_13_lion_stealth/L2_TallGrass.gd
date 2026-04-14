extends Area2D

signal lion_entered(lion)
signal lion_exited(lion)

func _on_body_entered(body):
	if body.has_method("enter_grass"):
		body.enter_grass()
		emit_signal("lion_entered", body)

func _on_body_exited(body):
	if body.has_method("exit_grass"):
		body.exit_grass()
		emit_signal("lion_exited", body)
