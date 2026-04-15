extends CharacterBody2D
var health = 100

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	$AnimatedSprite2D.play("dead")
	queue_free()
