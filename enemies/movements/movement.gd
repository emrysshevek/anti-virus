class_name Movement
extends Node

@export var speed: float = 50

var entity: Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready
	entity = get_parent()


	