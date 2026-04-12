extends CharacterBody2D
class_name ArmoredHyenaKingBoss
## Zebegna workflow: all S-26 code lives under res://tasks/task_26_scavenger_king/.
## S-17 rifle: after RayCast confirms a hit on this boss, call (no project.godot / autoload required):
##   get_tree().call_group("boss", "notify_rifle_hit_boss")
## Other systems: connect to `phase_two_entered` or read `hyena_king_exposed` on this node (signals, not UI coupling).

enum Phase { ONE, TWO }

signal phase_two_entered

@export var max_integrity: float = 500.0

var integrity: float
var phase: Phase = Phase.ONE
## Mirrors brief naming; true after rifle-driven phase break.
var hyena_king_exposed: bool = false

@onready var visuals: ScavengerKingVisuals = $Visuals


func _ready() -> void:
	integrity = max_integrity
	add_to_group("boss")
	add_to_group("hazard")
	visuals.set_phase(phase)


## Invoked by S-17 via call_group (see class docstring). Safe to call multiple times; only first phase break applies.
func notify_rifle_hit_boss() -> void:
	_on_rifle_hit_boss()


func _on_rifle_hit_boss() -> void:
	if phase != Phase.ONE:
		return
	phase = Phase.TWO
	hyena_king_exposed = true
	phase_two_entered.emit()
	visuals.set_phase(phase)


## Phase 1: sling and bow do nothing. Rifle and all weapons work in phase 2.
func take_damage(amount: float, weapon: Weapons.Kind) -> void:
	if phase == Phase.ONE:
		if weapon == Weapons.Kind.SLING or weapon == Weapons.Kind.BOW:
			return
	integrity -= amount
	if integrity <= 0.0:
		_die()


func _die() -> void:
	var encounter_root := get_parent()
	if encounter_root:
		encounter_root.queue_free()
	else:
		queue_free()


func is_phase_two() -> bool:
	return phase == Phase.TWO
