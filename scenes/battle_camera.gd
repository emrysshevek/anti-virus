class_name BattleCamera
extends Camera2D

@export var zoom_range := Vector2(5, 1)


var step_size := .01
var max_steps: float

func _ready() -> void:
	step_size = (zoom_range.y/zoom_range.x) ** (2 / Globals.game_duration)

func _process(delta: float) -> void:
	var time_weight = Globals.game_time_ratio()
	var steps = time_weight * max_steps
	var new_zoom = zoom_range.x * (step_size ** Globals.total_elapsed_time)
	zoom = Vector2(new_zoom, new_zoom)