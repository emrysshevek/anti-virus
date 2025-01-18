class_name Slow
extends Effect

@export var slow_factor := .5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	entity.max_speed *= slow_factor
	_remove_old_effect()

func _cleanup() -> void:
	entity.max_speed /= slow_factor 

