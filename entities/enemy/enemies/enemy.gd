class_name Enemy
extends Area2D

signal died(which_entity: Enemy)
signal reproduced(child: Enemy)
signal mutated(mutation: Enemy)

@export var lifespan: float = 5.0

@export var reproduction_chance: float = .5
@export var reproduction_count: float = 2
@export var mutation_chance: float = .01

@export var health: float = 10
@export var speed: float = 25
@export var turn_speed: float = 50
@export var damage: float = 1

@export var variation: float = .1
@export var randomize_stats: bool = true

@onready var lifespan_timer: Timer = $Timer

func _ready() -> void:
	if randomize_stats:
		_generate_random_stats()

	lifespan_timer.wait_time = lifespan
	lifespan_timer.start()

	print("Spawned enemy")

func _physics_process(delta: float) -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("enemy"):
			global_position += area.global_position.direction_to(global_position)


func _generate_random_stats() -> void:
	lifespan = max(lifespan * randf_range(1-variation, 1+variation), 1)

	reproduction_chance = clamp(reproduction_chance * randf_range(1-variation, 1+variation), 0, 1)
	mutation_chance = clamp(mutation_chance * randf_range(1-variation, 1+variation), 0, 1)

	health = max(health * randf_range(1-variation, 1+variation), 1)
	speed = max(speed * randf_range(1-variation, 1+variation), 0)
	turn_speed = max(health * randf_range(1-variation, 1+variation), 0)
	damage = max(health * randf_range(1-variation, 1+variation), 0)

func _reproduce() -> void:
	var parent = get_parent()
	for i in round(reproduction_count):
		var child = duplicate()
		parent.add_child(child)

		child.global_position = global_position + Vector2(randf_range(-1, 1), randf_range(-1,1))
		child.randomize_stats = true

		reproduced.emit(child)

func _mutate() -> void:
	mutated.emit()

func _on_timer_timeout() -> void:
	if reproduction_chance > 0 and randf() < reproduction_chance:
		_reproduce()

	died.emit(self)
	queue_free()
