extends ProgressBar

func _ready() -> void:
	min_value = 0.0
	max_value = 100.0

func _process(_delta) -> void:
	value = Global.player_thirst
