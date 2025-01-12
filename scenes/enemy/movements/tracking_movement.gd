class_name TrackingMovement
extends Movement

@export var target: Node2D
@export var turn_speed: float = 5.0

var target_pos: Vector2
var acceleration = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if target == null:
		target = get_tree().get_first_node_in_group("player")
		if target == null:
			return

	target_pos = target.global_position

	acceleration += seek()
	entity.velocity += acceleration * delta
	entity.velocity = entity.velocity.limit_length(speed)

func seek():
	var steer = Vector2.ZERO
	var desired = (target_pos - entity.global_position).normalized() * speed
	steer = (desired - entity.velocity).normalized() * turn_speed
	return steer


