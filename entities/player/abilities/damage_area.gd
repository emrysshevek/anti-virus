extends Area2D
class_name DamageArea

@export var damage: float = 3.0

func _on_body_entered(body:Node2D):
	if body.is_in_group("enemy"):
		print("Player entered DamageSquare!")
		body.take_damage(damage)
		printt(body.name,"was hit by a platelet! Their health is now " + str(body.health) + "!")


# func _on_area_entered(area:Area2D):
# 	if area is Projectile:
# 		print("Player entered DamageSquare!")
# 		area.health -= damage
# 		printt(area.name,"was hit by a platelet! Their health is now " + str(area.health) + "!")
