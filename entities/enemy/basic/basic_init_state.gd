class_name BasicInitState
extends EnemyState

func enter(previous_state_path: String, data := {}) -> void:
	pass

func physics_update(_delta: float) -> void:
	finished.emit(COOLDOWN)