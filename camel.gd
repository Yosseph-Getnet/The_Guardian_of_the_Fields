extends CharacterBody2D

var health: int = 100

func take_damage(amount: int):
	health -= amount
	print("Camel hit! Health:", health)

	if health <= 0:
		die()

func die():
	print("Camel died")
	queue_free()
