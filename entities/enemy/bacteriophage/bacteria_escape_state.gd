class_name BacteriaEscapState
extends BacteriophageState

var player

func enter(_previous_state_path: String, _data := {}) -> void:
    player = get_tree().get_first_node_in_group("player")
    bacteria.max_speed = bacteria.near_speed
    bacteria.moveable = true

func exit() -> void:
    bacteria.moveable = false

func physics_update(delta: float) -> void:
    bacteria.max_speed += (bacteria.near_speed - bacteria.max_speed) / 2 * delta

    var dist = player.global_position.distance_to(bacteria.global_position)
    var midpoint = (bacteria.hover_range.x + bacteria.hover_range.y) / 2.0
    if dist > midpoint:
        finished.emit(HOVER)

    var center = Vector2.ZERO
    var ortho_center: Vector2 = bacteria.global_position.direction_to(center).orthogonal()
    var away_from_player: Vector2 = player.global_position.direction_to(bacteria.global_position)
    var center_weight: float = sign(away_from_player.dot(ortho_center))
    var player_weight: float = 1
    var target_dir = (ortho_center * center_weight + away_from_player * player_weight).normalized()
    bacteria.target.global_position = bacteria.global_position + (target_dir * 10)