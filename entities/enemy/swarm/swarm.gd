class_name Swarm
extends Projectile

@export var entity_scene: PackedScene
@export var count := 5

var center: SwarmEntity
var swarm: Array[RemoteTransform2D] = []
var group_name: String

func _ready() -> void:
	group_name = str(randi())
	if entity_scene != null:
		_create_node()
	else:
		return

	for i in count-1:
		_create_node()

func _create_node() -> void:
	var node = entity_scene.instantiate()
	add_child(node)
	if not node.is_node_ready():
		await node.ready

	_add_entity.call_deferred(node)

func _add_entity(node: Node2D, type := SwarmEntity.SwarmEntityType.BODY) -> void:
	var entity = preload("res://entities/enemy/swarm/swarm_entity.tscn").instantiate()
	get_parent().add_child(entity)
	entity.type = type
	entity.group = group_name
	entity.swarm = self
	
	if not entity.is_node_ready():
		await entity.ready

	entity.global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	node.reparent(entity)
	node.position = Vector2.ZERO
	entity.add_to_group(entity.group)
	node.tree_exited.connect(func(): _remove_entity(entity))

func _remove_entity(entity: SwarmEntity) -> void:

	entity.queue_free()
