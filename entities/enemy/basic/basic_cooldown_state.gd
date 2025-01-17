class_name BasicCooldownState
extends EnemyState

@export var cooldown_duration := .75

var timer: Timer

func _ready() -> void:
	super._ready()
	timer = Timer.new()
	timer.wait_time = cooldown_duration
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func enter(previous_state_path: String, data := {}) -> void:
	timer.start()

func physics_update(_delta: float) -> void:
	entity.velocity *= 1 - entity.friction

func _on_timer_timeout() -> void:
	if entity.lifespan_timer.time_left == 0:
		entity._on_end_of_life()
		return
		
	if randf() < .5:
		finished.emit(MOVE)
		return
	
	timer.start()
