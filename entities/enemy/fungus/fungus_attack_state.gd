class_name FungusAttackState
extends FungusState

func physics_update(_delta: float) -> void:
	fungus.spawner.spawn()
	finished.emit(COOLDOWN)
