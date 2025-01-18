class_name BacteriaAttackState
extends BacteriophageState

func enter(_previous_state_path: String, _data := {}) -> void:
    bacteria.spawner.spawn(6, 1/6.0)

func physics_update(_delta: float) -> void:
    finished.emit(COOLDOWN)