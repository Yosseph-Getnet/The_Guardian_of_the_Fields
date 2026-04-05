extends Node2D
class_name Entity

# These are the shared variables the CEO mandates
var integrity = 100
var speed = 200

func take_damage(amount):
	integrity -= amount
	print("Unit hit! Current integrity: ", integrity)
	if integrity <= 0:
		die()

func die():
	print("Unit defeated.")
	queue_free() # This removes the character from the game
