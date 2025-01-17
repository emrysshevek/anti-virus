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
        if body.is_in_group("player") or body.is_in_group("enemy"):
            var explosion = preload("res://entities/attacks/explosion_attack.tscn").instantiate()
            get_parent().add_child(explosion)
            explosion.global_position = global_position
            queue_free()
            return
        