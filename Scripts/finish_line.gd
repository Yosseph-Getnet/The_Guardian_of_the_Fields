extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Check if the object entering is tagged as an 'objective'
	if body.is_in_group("objective"):
		
		# 1. Update the global score
		GameManager.score += 10
		print("Zebu saved! Current score: ", GameManager.score)
		
		# 2. THE PERFORMANCE FIX: 
		# Deletes the Zebu so it doesn't walk forever off-screen.
		body.queue_free()
