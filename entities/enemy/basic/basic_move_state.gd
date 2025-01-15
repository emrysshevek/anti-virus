class_name BasicMoveState
extends EnemyState

var timer: Timer

func _ready() -> void:
	super._ready()
	timer = Timer.new()
	timer.wait_time = .5
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
	if randf() < .25:
		finished.emit(COOLDOWN)
		return
	timer.start()
