class_name Enemy
extends Entity

signal reproduced(child: Enemy)
signal mutated(mutation: Enemy)
signal dropped_pickup(which_pickup: Pickup)

enum EnemyType {
	BASIC,
	FLU,
	FUNGUS,
	NEUROTOXIN,
	BACTERIA,
	HOOKWORM
}

@export var lifespan: float = 10.0

@export var reproduction_chance: float = 1
@export var reproduction_count: float = 2
@export var mutation_chance: float = 1

@export var stamina: float = .5
@export var variation: float = .1
@export var max_analyzation_time: int = 100
var current_analyzation_time: int = 0

@export var type: EnemyType

var target_position: Vector2
var self_scene: PackedScene
var instantiated := false

@onready var lifespan_timer: Timer = $Timer
@onready var onscreen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var detection_area: Area2D = $Detection

func _ready() -> void:
	print("Spawned ", str(type))
	print_stats()

	lifespan_timer.wait_time = lifespan
	lifespan_timer.start()

	Globals.enemy_counts[type] += 1
	
func _physics_process(delta: float) -> void:
	if current_analyzation_time >= max_analyzation_time:
		kill()
	
	if detection_area.monitoring:
		for area in detection_area.get_overlapping_areas():
			if area.get_parent().is_in_group("enemy"):
				global_position += area.global_position.direction_to(global_position)

	move_and_slide()

func _process(_delta):
	if instantiated and not onscreen_notifier.is_on_screen():
		print("somehow got offscreen")
		die()

	if not instantiated:
		print("instantiated")
		instantiated = true

	if current_analyzation_time >= max_analyzation_time:
		queue_free()

func print_stats() -> void:
	print("lifespan: ", lifespan, ", repro chance: ", reproduction_chance, ", repro count: ", reproduction_count, ", mutate chance: ", mutation_chance, ", health: ", health, ", max_speed: ", max_speed, ", turn max_speed: ", homing_speed, ", power: ", power)

func randomize_stats() -> void:
	lifespan = lifespan * randf_range(1-variation, 1+variation)

	mutation_chance = clamp(mutation_chance * randf_range(1-variation, 1+variation), 0, 1)

	health = max(health * randf_range(1-variation, 1+variation), 1)
	max_speed = max(max_speed * randf_range(1-variation, 1+variation), 0)
	homing_speed = max(homing_speed * randf_range(1-variation, 1+variation), 0)
	power = max(power * randf_range(1-variation, 1+variation), 0)

func clone() -> Enemy:
	if self_scene == null:
		_pack_self()
	var clone = self_scene.instantiate() as Enemy
	clone.self_scene = self_scene
	return clone
	
func analyze(percentage: int):
	current_analyzation_time += percentage
	print("")
	print("Analyzed: ", name, ", current time: ", current_analyzation_time, "/", max_analyzation_time)
	print("")
	if current_analyzation_time >= max_analyzation_time:
		die() 

func slow(rate:float):
	if not is_slowed:
		is_slowed = true
		temp_speed = max_speed
		max_speed /= rate
	elif is_slowed:
		max_speed = temp_speed
		is_slowed = false

func kill() -> void:
	if randf() < .2:
		var pickup: Pickup = preload("res://entities/pickups/pickup.tscn").instantiate()
		get_parent().add_child(pickup)
		pickup.global_position = global_position
		dropped_pickup.emit(pickup)
	die()

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
		child = init_child(child)

		parent.add_child(child)
		print("reproduced child")

		child.global_position = global_position + Vector2(randf_range(-1, 1), randf_range(-1,1))

		reproduced.emit(child)

func init_child(child: Enemy) -> Enemy:
	return

func mutate() -> Enemy:
	mutated.emit()
	return

func die() -> void:
	print("died")
	Globals.enemy_counts[type] -= 1
	super.die()

func _on_end_of_life() -> void:
	if reproduction_chance > 0 and randf() < reproduction_chance:
		_reproduce()

	die()

func _on_timer_timeout() -> void:
	_on_end_of_life()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("enemy died offscreen")
	die()
