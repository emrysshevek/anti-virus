class_name Rotator
extends Movement


func apply_movement(delta: float) -> void:
	entity.rotation += 2 * PI * entity.rps * delta
