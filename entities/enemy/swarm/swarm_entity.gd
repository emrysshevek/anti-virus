class_name SwarmEntity
extends RigidBody2D

enum SwarmEntityType {
	CENTER,
	BODY,
	MEMBRANE
}

@export var swarm: Swarm
@export var type: SwarmEntityType
@export var group: String
@export var center_weight := 1.0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	match type:
		SwarmEntityType.BODY:
			_process_body(state)
		SwarmEntityType.MEMBRANE:
			_process_membrane()
		
func _process_body(state: PhysicsDirectBodyState2D) -> void:
	print(swarm.global_position, " ", global_position)
	if swarm.global_position.distance_to(global_position) > 8:
		apply_central_impulse(global_position.direction_to(swarm.global_position))
	else:
		apply_central_impulse(swarm.global_position.direction_to(global_position) * .5)
	
	state.linear_velocity = state.linear_velocity.limit_length(100)
	
func _process_membrane() -> void:
	pass