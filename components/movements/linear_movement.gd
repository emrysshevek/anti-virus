class_name LinearMovement
extends Movement

func apply_movement(_delta: float) -> void:
	entity.velocity = entity.global_transform.x * entity.speed
