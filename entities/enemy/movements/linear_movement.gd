class_name LinearMovement
extends Movement

func _physics_process(delta: float) -> void:
	entity.position += entity.global_transform.x * speed * delta
