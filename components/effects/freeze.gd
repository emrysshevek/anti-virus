class_name Freeze
extends Effect

var position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_remove_old_effect()
	position = entity.position

func _physics_process(delta: float) -> void:
	entity.position = position
