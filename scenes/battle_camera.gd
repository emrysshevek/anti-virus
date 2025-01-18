class_name BattleCamera
extends Camera2D

@export var zoom_range := Vector2(5, 1)


func _process(delta: float) -> void:
	var time_weight = Globals.game_time_ratio()

	var zoom_factor = (1-time_weight) * zoom_range.x + time_weight * zoom_range.y

	zoom = Vector2(zoom_factor, zoom_factor)