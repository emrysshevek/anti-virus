class_name BasicMoveState
extends EnemyState

var timer: Timer

func _ready() -> void:
	super._ready()
	if not owner.is_node_ready():
		await owner.ready

	timer = Timer.new()
	timer.wait_time = entity.stamina
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func enter(_previous_state_path: String, _data := {}) -> void:
	timer.start()
	var center = Vector2.ZERO

	var basic := entity as Basic
	var bodies = basic.personal_space.get_overlapping_bodies().filter(func(x): return x is Basic and x != basic)
	for body in bodies:
		center += body.global_position
	if len(bodies) > 0:
		center /= len(bodies)

	var dir = center.direction_to(entity.global_position)

	# entity.look_at(entity.global_position + dir)
	entity.rotation_degrees = (rad_to_deg(entity.get_angle_to(center)) + 180) + randf_range(-5, 5)
	entity.moveable = true

func exit() -> void:
	entity.moveable = false

func _on_timer_timeout() -> void:
	if randf() < .5:
		finished.emit(COOLDOWN)
		return
	timer.start()
