class_name BacteriaChaseState
extends BacteriophageState


var player: Player

func enter(_previous_state_path: String, _data := {}) -> void:
    player = get_tree().get_first_node_in_group("player") as Player
    bacteria.moveable = true

func exit() -> void:
    bacteria.moveable = false

func physics_update(delta: float) -> void:
    bacteria.max_speed += (bacteria.far_speed - bacteria.max_speed) / 2 * delta

    var dist = player.global_position.distance_to(bacteria.global_position)
    var midpoint = (bacteria.hover_range.x + bacteria.hover_range.y) / 2.0
    if dist < midpoint:
        finished.emit(HOVER)

    bacteria.target.global_position = bacteria.global_position + (bacteria.global_position.direction_to(player.global_position) * 10)
