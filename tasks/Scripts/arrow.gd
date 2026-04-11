class_name Arrow extends Area2D

var speed: float = 300

func _ready() -> void:
	set_as_top_level(true)
	await get_tree().create_timer(10).timeout
	queue_free()

func _process(delta: float) -> void:
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
