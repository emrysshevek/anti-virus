class_name TrackingMovement
extends Movement

@export var target: Node2D

var target_pos: Vector2
var acceleration := Vector2.ZERO
var velocity := Vector2.ZERO

func apply_movement(delta: float) -> void:
	if target == null:
		target = get_tree().get_first_node_in_group("player")
		if target == null:
			return

	target_pos = target.global_position

	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.limit_length(entity.speed)

	entity.velocity = velocity

func seek():
	var steer = Vector2.ZERO
	var desired = (target_pos - entity.global_position).normalized() * entity.speed
	steer = (desired - velocity).normalized() * entity.homing_speed
	return steer


