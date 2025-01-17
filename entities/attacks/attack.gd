class_name Attack
extends Area2D

signal hit(entity: Node2D)
signal destroyed()

@export var health := 100
@export var duration := 50

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = duration
	timer.start()

func destroy() -> void:

	# if randf() < .2:
	# 	var pickup: Pickup = pickup_scene.instantiate()
	# 	get_parent().add_child(pickup)
	# 	pickup.global_position = global_position
	# 	dropped_pickup.emit(pickup)

	destroyed.emit()
	queue_free()

func _activate_effect(body: Node2D) -> void:
	pass


func _on_body_entered(body:Node2D) -> void:

	_activate_effect(body)

	# if not body.is_in_group("player"):
	# 	return
	
	# var player = body as Player
	# player.take_damage(1)
	# hit.emit(player)
	# destroy()

func _on_timer_timeout() -> void:
	destroy()
