class_name Rotator
extends Movement

@export var rps: float = 10

func apply_movement(delta: float) -> void: 
	if entity != null:
		rps = entity.rps

	node.rotation += 2 * PI * rps * delta
