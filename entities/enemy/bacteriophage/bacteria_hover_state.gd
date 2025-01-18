class_name BacteriaHoverState
extends BacteriophageState

var player: Player
var timer: SceneTreeTimer

func enter(_previous_state_path: String, _data := {}) -> void:
    player = get_tree().get_first_node_in_group("player")
    bacteria.max_speed = bacteria.near_speed
    bacteria.moveable = true

    timer = get_tree().create_timer(10)
    timer.timeout.connect(_on_timer_timeout)

func exit() -> void:
    bacteria.moveable = false
    timer.timeout.disconnect(_on_timer_timeout)

func physics_update(_delta: float) -> void:
    var dist = player.global_position.distance_to(bacteria.global_position)
    if dist < bacteria.hover_range.x:
        finished.emit(ESCAPE)
    elif dist > bacteria.hover_range.y:
        finished.emit(CHASE)
    
    var ortho = bacteria.global_position + bacteria.global_position.direction_to(player.global_position).orthogonal() * 10
    dist = (bacteria.hover_range.x + bacteria.hover_range.y) / 2
    var player_dir = player.global_position.direction_to(ortho) * dist
    bacteria.target.global_position = player.global_position + player_dir

func _on_timer_timeout() -> void:
    finished.emit(WINDUP)    
    