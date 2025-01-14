class_name Rotator
extends Movement

@export var rps := 5.0

func _physics_process(delta: float) -> void:
	entity.rotation += 2 * PI * rps * delta
