class_name Spawner
extends Node2D

@export var scene: PackedScene

func spawn(count: int = 1, delay: float = 0.0, parent: Node = null) -> void:
	for i in range(count):
		var instance = scene.instantiate() as Node2D
		if parent:
			parent.add_child(instance)
		else:
			get_parent().get_parent().add_child(instance)

		instance.transform = transform
		instance.global_position = global_position

		await get_tree().create_timer(delay).timeout