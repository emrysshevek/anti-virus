class_name WaveMovement
extends Movement

@export var amplitude := 1.0
@export var frequency := 1.0

var elapsed := 0.0

func apply_movement(delta: float) -> void:
	elapsed += delta

	
	var offset_dir = entity.velocity.normalized().orthogonal()
	var scale = amplitude * cos(2 * PI * frequency * elapsed)
	entity.position += offset_dir * scale
