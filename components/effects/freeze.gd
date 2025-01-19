class_name Freeze
extends Effect

var position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	for child in entity.get_children():
		if child is Effect and child.effect_name == effect_name:
			queue_free()
			return
	position = entity.position

func _physics_process(delta: float) -> void:
	entity.position = position
