class_name Projectile
extends Area2D

@export var health := 100
@export var damage := 10


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body:Node2D) -> void:
	if not body.is_in_group("player"):
		return
	#body.queue_free()
	body.take_damage(damage)
	queue_free()
