extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State { SOARING, DIVING }
var state = State.SOARING
var target: Node2D = null
var dive_speed: float = 250.0

func _ready():
	anim_sprite.play("Soaring")

func _process(delta):
	match state:
		State.SOARING:
			# animation already handled by PathFollow2D parent
			pass
		State.DIVING:
			if target:
				var direction = (target.global_position - global_position).normalized()
				position += direction * dive_speed * delta
				anim_sprite.play("Swooping")
