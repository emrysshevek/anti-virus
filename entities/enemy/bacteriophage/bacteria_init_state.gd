class_name BacteriaInitState
extends BacteriophageState


# func enter(_previous_state_path: String, _data := {}) -> void:

func physics_update(_delta: float) -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	var dist = player.global_position.distance_to(bacteria.global_position)
	bacteria.ap.speed_scale = 2
	bacteria.ap.play("walk")
	if dist < bacteria.hover_range.x:
		finished.emit(ESCAPE)
	elif dist > bacteria.hover_range.y:
		finished.emit(CHASE)
	else:
		finished.emit(HOVER)

func exit():
	bacteria.ap.speed_scale = 1
