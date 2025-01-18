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

func enter(previous_state_path: String, data := {}) -> void:
	timer.start()
	entity.rotation = 2 * PI * randf()
	entity.moveable = true

func exit() -> void:
	entity.moveable = false

func _on_timer_timeout() -> void:
	if randf() < .5:
		finished.emit(COOLDOWN)
		return
	timer.start()
