class_name ExplosionAttack
extends Attack


func _activate_attack(body: Node2D) -> void:
	if body is Entity:
		body.take_damage(10)