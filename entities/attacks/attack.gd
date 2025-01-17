class_name Attack
extends Area2D

signal hit(entity: Node2D)
signal destroyed()

@export var health := 100
@export var duration := 50.0

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = duration
	timer.start()

func destroy() -> void:
	destroyed.emit()
	queue_free()

func _activate_effect(body: Node2D) -> void:
	pass

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		_activate_effect(body)

func _on_timer_timeout() -> void:
	destroy()
