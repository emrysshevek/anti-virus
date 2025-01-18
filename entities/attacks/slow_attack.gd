class_name SlowAttack
extends Attack

func _activate_effect(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("slowing player")
		var player = body as Player
		var slow = preload("res://components/effects/slow.tscn").instantiate()
		player.add_child(slow)
		
