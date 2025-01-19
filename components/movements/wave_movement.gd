class_name WaveMovement
extends Movement

@export var amplitude := .5
@export var frequency := 1.0

var elapsed := 0.0

func apply_movement(delta: float) -> void:
	elapsed += delta
	
	var offset_dir = entity.velocity.normalized().orthogonal()
	if entity.velocity == Vector2.ZERO:
		offset_dir = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	var scale = amplitude * cos(2 * PI * frequency * elapsed)
	entity.position += offset_dir * scale
