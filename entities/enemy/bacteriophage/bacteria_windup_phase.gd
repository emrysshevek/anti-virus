class_name BacteriaWindupState
extends BacteriophageState

var timer: SceneTreeTimer

func enter(_previous_state_path: String, _data := {}) -> void:
    timer = get_tree().create_timer(2)
    timer.timeout.connect(_on_timer_timeout)
    bacteria.moveable = false

func physics_update(_delta: float) -> void:
    bacteria.velocity *= bacteria.friction

func _on_timer_timeout() -> void:
    finished.emit(ATTACK)