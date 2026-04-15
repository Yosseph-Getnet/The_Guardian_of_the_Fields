extends Node

var health: float = 100.0

func take_damage(amount: float) -> void:
	health -= amount
	if health < 0:
		health = 0
		
func is_dead() -> bool:
	return health <= 0
