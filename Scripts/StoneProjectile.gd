extends RigidBody2D

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    # Destroy eventually to clear memory if it rolls off-screen
    get_tree().create_timer(3.0).timeout.connect(queue_free)

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("enemies"):
        if body.has_method("take_damage"):
            body.take_damage(1)
        queue_free()
    elif body.is_in_group("ground"):
        # We can just let it bounce playfully on the ground, or disappear fast
        get_tree().create_timer(1.0).timeout.connect(queue_free)
