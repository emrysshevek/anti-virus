extends Area2D
class_name DamageArea

@export var damage: float = 50.0

func _on_body_entered(body:Node2D):
	if body is Projectile:
		print("Player entered DamageSquare!")
		body.health -= damage
		print(str(body.name) + " was hit by a platelet! Their health is now ${body.health}!")


# func _on_area_entered(area:Area2D):
# 	if area is Projectile:
# 		print("Player entered DamageSquare!")
# 		area.health -= damage
# 		printt(area.name,"was hit by a platelet! Their health is now " + str(area.health) + "!")
