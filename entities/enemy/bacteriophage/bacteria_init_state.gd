class_name BacteriaInitState
extends BacteriophageState


func physics_update(_delta: float) -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	var dist = player.global_position.distance_to(bacteria.global_position)
	
	if dist < bacteria.hover_range.x:
		finished.emit(ESCAPE)
	elif dist > bacteria.hover_range.y:
		finished.emit(CHASE)
	else:
		finished.emit(HOVER)
