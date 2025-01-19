extends Area2D
class_name SporeBullet

@export var speed: float = 50.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
    # Move the projectile in the given direction
    position += direction * speed * delta

    if position.length() > 4000: 
        queue_free()

func _on_body_entered(body: Node):
    if body.is_in_group("enemy"):
        body.take_damage(2)
        #queue_free()