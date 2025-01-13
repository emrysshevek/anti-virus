class_name Movement
extends Node

@export var speed: float = 50

var entity: Projectile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not get_parent().is_node_ready():
		await get_parent().ready

	entity = get_parent()
