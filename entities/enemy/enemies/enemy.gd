class_name Enemy
extends CharacterBody2D

signal died(which_entity: Enemy)
signal reproduced(child: Enemy)
signal mutated(mutation: Enemy)

@export var lifespan: float = 10.0

@export var reproduction_chance: float = 0
@export var reproduction_count: float = 2
@export var mutation_chance: float = .2

@export var health: float = 10
@export var speed: float = 30
@export var homing_speed: float = 50
@export var rps: float = 5
@export var friction: float = .05
@export var damage: float = 1

@export var variation: float = .1

var target_position: Vector2
var self_scene: PackedScene
var moveable = false

@onready var lifespan_timer: Timer = $Timer

func _ready() -> void:
	print("Spawned enemy")
	randomize_stats()
	print_stats()

	lifespan_timer.wait_time = lifespan
	lifespan_timer.start()


func _physics_process(delta: float) -> void:
	for area in $Detection.get_overlapping_areas():
		if area.get_parent().is_in_group("enemy"):
			global_position += area.global_position.direction_to(global_position)
	
	move_and_slide()

func print_stats() -> void:
	print("lifespan: ", lifespan, ", repro chance: ", reproduction_chance, ", repro count: ", reproduction_chance, "mutate chance: ", mutation_chance, ", health: ", health, ", speed: ", speed, ", turn speed: ", homing_speed, ", damage: ", damage)

func randomize_stats() -> void:
	lifespan = lifespan * randf_range(1-variation, 1+variation)

	reproduction_chance = clamp(reproduction_chance * randf_range(1-variation, 1+variation), 0, 1)
	mutation_chance = clamp(mutation_chance * randf_range(1-variation, 1+variation), 0, 1)

	health = max(health * randf_range(1-variation, 1+variation), 1)
	speed = max(speed * randf_range(1-variation, 1+variation), 0)
	homing_speed = max(health * randf_range(1-variation, 1+variation), 0)
	damage = max(health * randf_range(1-variation, 1+variation), 0)

func clone() -> Enemy:
	if self_scene == null:
		_pack_self()
	var clone = self_scene.instantiate() as Enemy
	clone.self_scene = self_scene
	return clone
	

func _pack_self() -> void:
	print("packing self")
	_recursive_set_owner(self)
	self_scene = PackedScene.new()
	var result = self_scene.pack(self)
	if result != OK:
		push_error(error_string(result))
	

func _recursive_set_owner(node: Node) -> void:
	for child in node.get_children():
		child.owner = self
		_recursive_set_owner(child)

func _reproduce() -> void:
	var parent = get_parent()
	for i in round(reproduction_count):
		var child = clone()
		if randf() < mutation_chance:
			child.mutate()

		parent.add_child(child)

		child.global_position = global_position + Vector2(randf_range(-1, 1), randf_range(-1,1))

		reproduced.emit(child)

func mutate() -> void:
	mutated.emit()

func _on_end_of_life() -> void:
	if reproduction_chance > 0 and randf() < reproduction_chance:
		_reproduce()

	died.emit(self)
	queue_free()

func _on_timer_timeout() -> void:
	pass