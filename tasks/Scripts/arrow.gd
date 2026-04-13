class_name Arrow extends Area2D

var speed: float = 300
var damage: float = 50

func _ready() -> void:
	set_as_top_level(true)
	await get_tree().create_timer(10).timeout
	queue_free()

func _process(delta: float) -> void:
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	hit(area)
	
func _on_body_entered(body: Node2D) -> void:
	hit(body)
	
func hit(target) -> void:
	if target == self:
		return

	if target.is_in_group("Hazard"):
		target.TakeDamage(damage, "arrow")
		queue_free()
		return

	if target.is_in_group("Defendable Entity"):
		target.TakeDamage(damage, Global.friendly_fire_enabled)
		queue_free()
		return

	queue_free()
