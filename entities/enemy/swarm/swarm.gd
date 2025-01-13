class_name Swarm
extends Projectile

signal swarm_destroyed(which_swarm: Swarm)

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
	entity.node = node
	entity.type = type
	entity.group = group_name
	entity.swarm = self
	get_parent().add_child(entity)
	
	if not entity.is_node_ready():
		await entity.ready

	entity.global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	entity.add_to_group(entity.group)
	entity.entity_destroyed.connect(_on_entity_destroyed)

func _on_entity_destroyed(entity: SwarmEntity) -> void:
	if get_tree().get_node_count_in_group(group_name) <= 1:
		swarm_destroyed.emit(self)
		queue_free.call_deferred()
	else:
		print(get_tree().get_node_count_in_group(group_name))
