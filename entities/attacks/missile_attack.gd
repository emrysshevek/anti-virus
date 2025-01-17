class_name MissileAttack
extends Enemy


func _on_detection_body_entered(body:Node2D) -> void:
    if body.is_in_group("player"):
        var player = body as Player
        player.take_damage(1)
        queue_free()
    elif body.is_in_group("enemy"):
        var enemy = body as Enemy
        enemy.kill()
        queue_free()
