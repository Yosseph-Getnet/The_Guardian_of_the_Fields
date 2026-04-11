extends Node

signal dust_triggered

var is_switch_needed: bool = false

func enable_switch():
	is_switch_needed = true
	emit_signal("dust_triggered")
