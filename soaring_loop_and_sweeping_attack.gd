func set_animation():
	if state == State.SOARING:
		$AnimatedSprite2D.play("soaring_loop")
	elif state == State.SWOOPING:
		$AnimatedSprite2D.play("swooping_attack")
