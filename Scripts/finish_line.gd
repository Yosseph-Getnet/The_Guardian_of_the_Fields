extends Area2D

var triggered = false

func _on_body_entered(body):
	# We check the name 'zebu' defined in your scene 
	if body.name == "zebu" and not triggered:
		triggered = true
		GameManager.score += 10
		print("Score updated! Current score: ", GameManager.score)
