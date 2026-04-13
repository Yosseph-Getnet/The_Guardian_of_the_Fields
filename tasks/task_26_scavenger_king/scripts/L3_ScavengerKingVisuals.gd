extends Node2D
class_name L3_ScavengerKingVisuals
## Phase 1 = armored, Phase 2 = exposed (swap textures + visibility).
##
## Hooking real art:
## 1. Export PNGs into `res://tasks/task_26_scavenger_king/assets/` (or your lead’s path).
## 2. Assign **texture_armored** / **texture_exposed** on this node, or set child Sprite2D textures.
## 3. For animations, use **AnimatedSprite2D** + **SpriteFrames** and drive from `set_phase`.

var _sprite_armored: Sprite2D
var _sprite_exposed: Sprite2D

@export var texture_armored: Texture2D
@export var texture_exposed: Texture2D


func _ready() -> void:
	_sprite_armored = get_node_or_null("SpritePhase1") as Sprite2D
	_sprite_exposed = get_node_or_null("SpritePhase2") as Sprite2D
	if _sprite_armored == null or _sprite_exposed == null:
		push_error("L3_ScavengerKingVisuals: expected child nodes SpritePhase1 and SpritePhase2.")
		return
	if texture_armored != null:
		_sprite_armored.texture = texture_armored
	if texture_exposed != null:
		_sprite_exposed.texture = texture_exposed


func set_phase(phase: Variant) -> void:
	if _sprite_armored == null or _sprite_exposed == null:
		return
	var phase_two: bool = int(phase) != 0
	_sprite_armored.visible = not phase_two
	_sprite_exposed.visible = phase_two
