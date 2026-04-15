extends Node2D

var is_condition_triggered: bool = false

func blowing_dust_trigger_condition():
	is_condition_triggered = true
	$EnvironmentCondition.enable_switch()
