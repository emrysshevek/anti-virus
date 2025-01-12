class_name Spawner
extends Node2D

@export var scene: PackedScene

func spawn(new_scene: PackedScene = null, parent: Node = null, count: int = 1, delay: float = 0.0) -> void:
	if new_scene == null:
		new_scene = self.scene

	for i in range(count):
		var instance = new_scene.instantiate()
		if parent:
			parent.add_child(instance)
		else:
			add_child(instance)
		await get_tree().create_timer(delay).timeout
