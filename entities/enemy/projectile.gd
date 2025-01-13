class_name Projectile
extends Area2D

signal hit(entity: Node2D)
signal destroyed()
signal dropped_pickup(which_pickup: Pickup)

@export var health := 100
@export var duration := 50

@onready var pickup_scene = preload("res://entities/pickups/pseudopod_pickup.tscn")
@onready var timer = $Timer

func _ready() -> void:
	timer.wait_time = duration
	# timer.start()

func destroy() -> void:

	if randf() < .2:
		var pickup: Pickup = pickup_scene.instantiate()
		get_parent().add_child(pickup)
		pickup.global_position = global_position
		dropped_pickup.emit(pickup)

	destroyed.emit()
	queue_free()


func _on_body_entered(body:Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	hit.emit(body as Player)
	destroy()

func _on_timer_timeout() -> void:
	destroy()
