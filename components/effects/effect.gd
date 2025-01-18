class_name Effect
extends Node

@export var effect_name := "Unknown"
@export var duration := 5.0

var entity: Player

@onready var timer: Timer = $Timer

func _ready() -> void:
	entity = get_parent()
	assert(entity != null, "effect parent must be Player")
	
	timer.wait_time = duration
	timer.start()

func _remove_old_effect() -> void:
	for child in entity.get_children():
		if child is Effect and child.effect_name == effect_name and child != self:
			print("replacing previously applied effect of type ", child.effect_name, " with effect of type ", effect_name)
			child.end()

func end() -> void:
	_cleanup()
	queue_free.call_deferred()

func _cleanup() -> void:
	pass

func _on_timer_timeout() -> void:
	print(effect_name, " effect ended")
	end()
