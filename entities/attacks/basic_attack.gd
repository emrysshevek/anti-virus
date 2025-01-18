class_name BasicAttack
extends Attack


func _activate_attack(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	var player = body as Player
	player.take_damage(1)
	hit.emit(player)
	destroy()