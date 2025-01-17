class_name FreezeAttack
extends Attack

func _activate_effect(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("freezing player")
		var player = body as Player
		var freeze = preload("res://components/effects/freeze.tscn").instantiate()
		player.add_child(freeze)
