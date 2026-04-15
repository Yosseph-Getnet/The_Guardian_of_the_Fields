extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_process(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_process(false)

func _process(delta: float) -> void:
	Global.player_stamina = clamp(
		Global.player_stamina + (10.0 * 2.0 * delta), 
		0.0, 100.0
	)
