class_name Rotator
extends Node2D

@export var rps := 5.0

var entity: Node2D

func _ready() -> void:
	if not get_parent().is_node_ready():
		await get_parent().ready
	
	entity = get_parent()

func _physics_process(delta: float) -> void:
	entity.rotation += 2 * PI * rps * delta
