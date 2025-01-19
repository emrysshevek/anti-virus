class_name Entity
extends CharacterBody2D

signal died(which_entity: Entity)
signal damaged(which_entity: Entity)

@export var health := 10
@export var power := 5
@export var max_speed := 400.0
@export var homing_speed := 50.0
@export var rps: float = 5
@export var moveable := true
@export var friction: float = .05
@export var is_slowed = false
var temp_speed = max_speed

func take_damage(damage) -> void:
	if damage < 0:
		return
	
	health -= damage
	print(name, " current health: ", str(health))
	damaged.emit(self)

	if health <= 0:
		die()

func die() -> void:
	died.emit(self)
	queue_free()