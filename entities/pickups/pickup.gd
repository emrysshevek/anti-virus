class_name Pickup
extends Area2D

enum PickupType {
	PSEUDOPOD,
	METABOLISM,
	MEMBRANE
}

var type: PickupType

func pickup(player: Player) -> void:
	queue_free()

