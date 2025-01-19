class_name ExplosionAttack
extends Attack


func _activate_attack(body: Node2D) -> void:
	add_child(preload("res://assets/sprite scenes/explosion.tscn").instantiate())
	if body is Entity:
		body.take_damage(10)