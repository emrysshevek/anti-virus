class_name Projectile
extends Entity

signal hit(entity: Node2D)
signal destroyed()

@export var duration := 10

@onready var timer = $Timer

func _ready() -> void:
	timer.wait_time = duration
	timer.start()

func destroy() -> void:
	destroyed.emit()
	queue_free()

func _process(_delta):
	if health <= 0:
		destroy()

func _on_body_entered(body:Node2D) -> void:
	
	if body.is_in_group("shield"):
		take_damage(health * 2)
	elif not body.is_in_group("player"):
		return
	
	hit.emit(body as Player)
	destroy()

func _on_timer_timeout() -> void:
	destroy()
