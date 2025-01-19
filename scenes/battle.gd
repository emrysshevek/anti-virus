class_name Battle
extends Node2D

var elapsed := 0.0

func _process(delta: float) -> void:
	elapsed += delta

	if elapsed >= 2:
		elapsed = 0.0

		add_child(preload("res://entities/enemy/basic/basic.tscn").instantiate())