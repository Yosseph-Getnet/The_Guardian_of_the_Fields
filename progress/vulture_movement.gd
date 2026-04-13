extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	anim_sprite.play("Soaring")
