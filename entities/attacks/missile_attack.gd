class_name MissileAttack
extends Enemy



func _physics_process(delta: float) -> void:

    if lifespan - lifespan_timer.time_left >= .5:
        _detect_collision()

    if lifespan_timer.time_left <= 2.5:
        max_speed *= .99

    move_and_slide()    

func _detect_collision() -> void:
    for body in $Detection.get_overlapping_bodies():
        if body.is_in_group("player"):
            var player = body as Player
            player.take_damage(1)
            queue_free()
        elif body.is_in_group("enemy"):
            var enemy = body as Enemy
            enemy.kill()
            queue_free()