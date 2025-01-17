class_name FungusMoveState
extends FungusState

var target: Vector2
var timer: SceneTreeTimer

func enter(_previous_state_path: String, _data := {}) -> void:
	fungus.moveable = true

func exit() -> void:
	fungus.moveable = false

func physics_update(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player") as Player

	if player == null:
		return

	if player.global_position.distance_to(fungus.global_position) > fungus.hover_distance:
		finished.emit(WINDUP)
