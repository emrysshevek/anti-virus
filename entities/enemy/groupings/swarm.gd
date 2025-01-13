class_name Swarm
extends Projectile

@export var entity_scene: PackedScene
@export var count := 5
@export var cohesion_weight := 1.0
@export var separation_weight := 1.0
@export var alignment_weight := 1.0
@export var goal_weight := 1.0


var entity: Node2D
var swarm: Array[RemoteTransform2D] = []
var swarm_velocities: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if entity_scene != null:
		entity = entity_scene.instantiate()
		get_parent().add_child(entity)
	elif len(get_children()) > 0:
		entity = get_child(0)
	else:
		return

	add_boid.call_deferred(entity)

	while len(swarm) < count:
		var clone = entity.duplicate()
		clone.global_position = global_position
		get_parent().add_child.call_deferred(clone)
		add_boid.call_deferred(clone)
		add_boid(clone)

func _physics_process(delta: float) -> void:
	var cohesion: Vector2
	var separation: Vector2
	var alignment: Vector2
	var goal: Vector2

	for i in range(len(swarm)):
		var boid = swarm[i]

		cohesion = _calculate_cohesion(boid) * cohesion_weight
		separation = _calculate_separation(boid) * separation_weight
		alignment = _calculate_alignment(boid) * alignment_weight
		# goal = _calculate_goal(boid) * goal_weight

		swarm_velocities[i] = (swarm[i].global_position.direction_to(global_position) * swarm[i].global_position.distance_squared_to(global_position)) + cohesion + separation + alignment + goal
		boid.position += swarm_velocities[i].limit_length(50) * delta

func add_boid(entity: Node2D) -> RemoteTransform2D:
	var boid = RemoteTransform2D.new()
	boid.top_level = true
	add_child.call_deferred(boid)
	_init_boid(boid, entity)
	swarm.append(boid)
	swarm_velocities.append(Vector2.ZERO)
	entity.tree_exited.connect(func(): remove_boid(boid))
	return boid

func _init_boid(boid: RemoteTransform2D, entity: Node2D) -> void:
	if not entity.is_node_ready():
		await entity.ready
	boid.global_position = entity.global_position + Vector2(randf_range(-30, 30), randf_range(-30, 30))
	boid.remote_path = entity.get_path()

func remove_boid(boid: RemoteTransform2D) -> void:
	var idx = swarm.find(boid)
	swarm[idx].queue_free()
	swarm.remove_at(idx)
	swarm_velocities.remove_at(idx)

func _calculate_cohesion(boid: RemoteTransform2D) -> Vector2:
	var center = Vector2.ZERO

	for other in swarm:
		if boid != other:
			center += other.global_position
	
	center /= len(swarm) - 1

	return (center - boid.global_position) / 100

func _calculate_separation(boid: RemoteTransform2D) -> Vector2:
	var dir := Vector2.ZERO

	for other in swarm:
		if boid != other:
			if boid.global_position.distance_to(other.global_position) < 8:
				var vect_to = boid.global_position.direction_to(other.global_position)
				vect_to *= min(boid.global_position.distance_to(other.global_position), 10)
				dir = dir - vect_to
				print("updating dir: ", dir)
	
	return dir

func _calculate_alignment(boid: RemoteTransform2D) -> Vector2:
	var dir = Vector2.ZERO
	for other in swarm:
		if boid != other:
			dir += swarm_velocities[swarm.find(other)]
	dir /= len(swarm) - 1
	return (dir - swarm_velocities[swarm.find(boid)]) / 8

func _calculate_goal(boid: RemoteTransform2D) -> Vector2:
	return (global_position - boid.global_position)
	