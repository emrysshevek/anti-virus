extends Area2D
class_name DamageSquare

@export var damage: int

func _ready():
    pass

func _on_body_entered(body):
    
    if body.is_in_group("player"):
        print("Player entered DamageSquare!")
        
        body.take_damage(damage)