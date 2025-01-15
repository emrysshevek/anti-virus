class_name Movement
extends Node

var entity: Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not get_parent().is_node_ready():
		await get_parent().ready

	entity = get_parent()

func _physics_process(delta: float) -> void:
	if entity.moveable:
		apply_movement(delta)

func apply_movement(_delta: float) -> void:
	pass
