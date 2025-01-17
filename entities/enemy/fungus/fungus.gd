class_name Fungus
extends Enemy

@export var hover_distance := 50.0

@onready var target: Node2D = $Target
@onready var spawner: Spawner = $Spawner

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_update_target()

func _update_target() -> void:
	var player = get_tree().get_first_node_in_group("player") as Player

	if player == null:
		return

	var center = Vector2.ZERO
	var ortho_center: Vector2 = global_position.direction_to(center).orthogonal()
	var away_from_player: Vector2 = player.global_position.direction_to(global_position)
	var center_weight: float = sign(away_from_player.dot(ortho_center))
	var player_weight: float = 1
	var target_dir = (ortho_center * center_weight + away_from_player * player_weight).normalized()

	target.global_position = global_position + target_dir * hover_distance


