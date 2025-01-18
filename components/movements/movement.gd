class_name Movement
extends Node

@export var movement_name: String
@export var movement_type: String

var node: Node2D
var entity: Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not get_parent().is_node_ready():
		await get_parent().ready

	node = get_parent() as Node2D
	entity = node as Entity
	# assert(entity != null, "Move component parent must be a Node2D")


func _physics_process(delta: float) -> void:
	if entity == null or entity.moveable:
		apply_movement(delta)

func apply_movement(_delta: float) -> void:
	pass
