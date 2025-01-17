class_name FungusWindupState
extends FungusState

var timer: SceneTreeTimer
var player: Player

func enter(_previous_state_path: String, _data := {}) -> void:
	player = get_tree().get_first_node_in_group("player")
	print("windup player: ", player)
	timer = get_tree().create_timer(1)
	timer.timeout.connect(_on_timer_timeout)

func exit() -> void:
	timer.timeout.disconnect(_on_timer_timeout)

func physics_update(_delta: float) -> void:
	fungus.velocity *=  1 - fungus.friction

	if player != null and player.global_position.distance_to(fungus.global_position) < fungus.hover_distance:
		finished.emit(MOVE)

func _on_timer_timeout() -> void:
	finished.emit(ATTACK)
