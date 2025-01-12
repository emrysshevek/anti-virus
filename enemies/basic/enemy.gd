class_name Enemy
extends CharacterBody2D

@export var health := 100

func _physics_process(delta: float) -> void:
	move_and_slide()

