class_name SwarmEntity
extends RigidBody2D

signal entity_destroyed(which_entity: SwarmEntity)

enum SwarmEntityType {
	CENTER,
	BODY,
	MEMBRANE
}

@export var swarm: Swarm
@export var type: SwarmEntityType
@export var group: String
@export var node: Node2D

@onready var holder = $NodeHolder

func _ready() -> void:
	assert(node != null)
	node.global_position = global_position
	node.reparent(holder)
	node.tree_exited.connect(_on_node_exited)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	match type:
		SwarmEntityType.BODY:
			_process_body(state)
		SwarmEntityType.MEMBRANE:
			_process_membrane()
		
func _process_body(state: PhysicsDirectBodyState2D) -> void:
	if swarm.global_position.distance_to(global_position) > 8:
		apply_central_impulse(global_position.direction_to(swarm.global_position))
	else:
		apply_central_impulse(swarm.global_position.direction_to(global_position))
	
	state.linear_velocity = state.linear_velocity.limit_length(100)
	
func _process_membrane() -> void:
	pass

func _on_node_exited() -> void:
	for child in holder.get_children():
		child.reparent.call_deferred(get_parent())

	entity_destroyed.emit(self)
	queue_free.call_deferred()
