class_name BasicInitState
extends EnemyState

func enter(previous_state_path: String, data := {}) -> void:
	entity.moveable = false

func physics_update(_delta: float) -> void:
	finished.emit(COOLDOWN)
