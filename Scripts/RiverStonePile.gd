extends Area2D

var player_in_range: Node2D = null

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        player_in_range = body

func _on_body_exited(body: Node2D) -> void:
    if body == player_in_range:
        player_in_range = null

func _process(_delta: float) -> void:
    # Player reloads pressing E when close
    if player_in_range and Input.is_key_pressed(KEY_E):
        if Global.current_ammo < Global.max_ammo:
            Global.current_ammo = Global.max_ammo
            
            # Flash pile white to signify successful reload
            var tween = create_tween()
            tween.tween_property($Sprite2D, "modulate", Color(2, 2, 2), 0.1)
            tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.1)
