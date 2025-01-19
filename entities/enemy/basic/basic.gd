class_name Basic
extends Enemy

@export var max_count: int = 25
@export var health_range: Vector2 = Vector2(3, 15)
@export var lifespan_range := Vector2(2, 30)
@export var speed_range := Vector2(15, 50)
@export var homing_range := Vector2(10, 100)
@export var stamina_range := Vector2(.5, 5)
@export var mutation_range := Vector2(0, .5)

var movements = [
	MovementWrapper.new("linear", "propulsion", preload("res://components/movements/linear_movement.tscn")),
	MovementWrapper.new("track", "propulsion", preload("res://components/movements/tracking_movement.tscn")),
	MovementWrapper.new("wave", "modifier", preload("res://components/movements/wave_movement.tscn")),
	MovementWrapper.new("rotate", "modifier", preload("res://components/movements/rotation.tscn")),
]


var movement_propulsion: Movement
var movement_modifiers: Array[Movement]

@onready var personal_space: Area2D = $PersonalSpaceArea

func init_child(child: Enemy) -> void:
	var basic = child as Basic
	var time_weight := Globals.game_time_ratio()

	basic.health = (((1 - time_weight) * health_range.x ) + (time_weight * health_range.y)) * randf_range(1-variation, 1+variation)
	basic.lifespan = (((1 - time_weight) * lifespan_range.x) + (time_weight * lifespan_range.y)) * randf_range(1-variation, 1+variation)
	basic.max_speed = ((1 - time_weight) * speed_range.x + time_weight * speed_range.y) * randf_range(1-variation, 1+variation)
	basic.homing_speed = ((1 - time_weight) * homing_range.x + time_weight * homing_range.y) * randf_range(1-variation, 1+variation)
	basic.stamina = ((1 - time_weight) * stamina_range.x + time_weight * stamina_range.y) * randf_range(1-variation, 1+variation)
	basic.mutation_chance = ((1 - time_weight) * mutation_range.x + time_weight * mutation_range.y) * randf_range(1-variation, 1+variation)

	if randf() < mutation_chance:
		basic.mutate()

func mutate() -> void:
	print("mutating cell")

	var rng = randf()
	var type: String = "any"

	if rng < .5:
		type = _add_movement()
	else:
		type = _swap_movement()

	if type != "any":
		_pack_self()

func _add_movement(type: String = "any") -> String:
	var component_names = movement_modifiers.map(func(x): return x.movement_name)

	var available_scenes = []
	match type:
		"modifier":
			available_scenes.append_array(movements.filter(func(x): return x.type == "modifier" and x.name not in component_names))
		"propulsion":
			available_scenes.append_array(movements.filter(func(x): return x.type == "propulsion" and movement_propulsion == null or x.name != movement_propulsion.movement_name))
		"any":
			available_scenes.append_array(movements.filter(func(x): return x.type == "modifier" and x.name not in component_names))
			available_scenes.append_array(movements.filter(func(x): return x.type == "propulsion" and (movement_propulsion == null or x.name != movement_propulsion.movement_name)))

	if len(available_scenes) == 0:
		return ""

	if movement_propulsion == null:
		available_scenes.append_array(movements.filter(func(x): return x.type == "propulsion"))
	
	var to_add = available_scenes.pick_random()
	var movement: Movement = to_add.instantiate()
	add_child(movement)

	if movement.movement_type == "propulsion":
		movement_propulsion = movement
	else:
		movement_modifiers.append(movement)

	print("  added movement: ", to_add.name)
	return to_add.type

func _remove_movement(type: String = "any") -> String:
	var components: Array[Movement] = []
	match type:
		"any":
			components.append_array(movement_modifiers)
			if movement_propulsion != null:
				components.append(movement_propulsion)
		"propulsion":
			if movement_propulsion != null:
				components.append(movement_propulsion)
		"modifier":
			components.append_array(movement_modifiers)

	if len(components) == 0:
		return "any"

	var to_remove = components.pick_random()
	to_remove.queue_free.call_deferred()
	if to_remove == movement_propulsion:
		movement_propulsion = null
	else:
		movement_modifiers.erase(to_remove)
	
	print("  removed movement: ", to_remove.name)
	return to_remove.type

func _swap_movement(type:="any") -> String:
	type = _remove_movement(type)
	_add_movement(type)

	return type

func _on_end_of_life() -> void:
	reproduction_chance = 1 - (Globals.enemy_counts[type] / float(max_count * reproduction_count))
	super._on_end_of_life()

func _on_timer_timeout() -> void:
	pass # handle end of life in cooldown