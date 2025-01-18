class_name BacteriaCooldownState
extends BacteriophageState

var timer: SceneTreeTimer

func enter(_previous_state_path: String, _data := {}) -> void:
    timer = get_tree().create_timer(5)
    timer.timeout.connect(func(): finished.emit(INIT))
