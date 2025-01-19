class_name Basic
extends Enemy

@export var max_count: int = 10
@export var health_range: Vector2 = Vector2(3, 15)
@export var lifespan_range := Vector2(2, 30)
@export var speed_range := Vector2(15, 50)
@export var homing_range := Vector2(10, 100)
@export var stamina_range := Vector2(.5, 5)
@export var mutation_range := Vector2(.1, .75)

var movements = [
	MovementWrapper.new("linear", "propulsion", preload("res://components/movements/linear_movement.tscn")),
	MovementWrapper.new("track", "propulsion", preload("res://components/movements/tracking_movement.tscn")),
	MovementWrapper.new("wave", "modifier", preload("res://components/movements/wave_movement.tscn")),
	MovementWrapper.new("rotate", "modifier", preload("res://components/movements/rotation.tscn")),
]

var movement_propulsion: Movement
var movement_modifiers: Array[Movement]

@onready var personal_space: Area2D = $PersonalSpaceArea

func init_child(child: Enemy) -> Enemy:
	var basic = child as Basic
	var time_weight := Globals.game_time_ratio()

	basic.health = (((1 - time_weight) * health_range.x ) + (time_weight * health_range.y)) * randf_range(1-variation, 1+variation)
	basic.lifespan = (((1 - time_weight) * lifespan_range.x) + (time_weight * lifespan_range.y)) * randf_range(1-variation, 1+variation)
	basic.max_speed = ((1 - time_weight) * speed_range.x + time_weight * speed_range.y) * randf_range(1-variation, 1+variation)
	basic.homing_speed = ((1 - time_weight) * homing_range.x + time_weight * homing_range.y) * randf_range(1-variation, 1+variation)
	basic.stamina = ((1 - time_weight) * stamina_range.x + time_weight * stamina_range.y) * randf_range(1-variation, 1+variation)
	basic.mutation_chance = ((1 - time_weight) * mutation_range.x + time_weight * mutation_range.y) * randf_range(1-variation, 1+variation)

	if randf() < mutation_chance:
		child = basic.mutate()

	return child

func mutate() -> Enemy:
	var time = Globals.total_elapsed_time

	if time < 15:
		return phase0_mutation()
	elif time < 120:
		return phase1_mutation()
	elif time < 240:
		return phase2_mutation()
	elif time < 360:
		return phase3_mutation()
	else:
		return phase1_mutation()
		
	return null

func phase0_mutation() -> Enemy:
	return self

func phase1_mutation() -> Enemy:
	var type: String = "any"
	var rng = randf()
	if rng < .33:
		type = _add_movement()
	elif rng < .66:
		type = _swap_movement()
	else:
		return phase0_mutation()

	if type != "any":
		print("mutated cell")
		_pack_self()
	return self

func phase2_mutation() -> Enemy:
	if Globals.enemy_counts[Enemy.EnemyType.FUNGUS] <= 0:
		return preload("res://entities/enemy/fungus/fungus.tscn").instantiate()
	elif Globals.enemy_counts[Enemy.EnemyType.NEUROTOXIN] <= 0:
		return preload("res://entities/enemy/neurotoxin/neurotoxin.tscn").instantiate()

	return phase1_mutation()

func phase3_mutation() -> Enemy:
	if Globals.enemy_counts[Enemy.EnemyType.BACTERIA] <= 0:
		return preload("res://entities/enemy/bacteriophage/bacteriophage.tscn").instantiate()
	else:
		return phase2_mutation()

func _add_movement(type: String = "any", component: Movement = null) -> String:
	print("adding movement type: ", type, ", component=", component)
	var movement: Movement

	if component != null:
		movement = component
	else:
		var component_names = movement_modifiers.map(func(x): return x.movement_name)

		var available_scenes = []
		match type:
			"modifier":
				available_scenes.append_array(movements.filter(func(x): return x.type == "modifier" and x.name not in component_names))
			"propulsion":
				if movement_propulsion == null:
					available_scenes.append_array(movements.filter(func(x): return x.type == "propulsion"))
			"any":
				available_scenes.append_array(movements.filter(func(x): return x.type == "modifier" and x.name not in component_names))
				if movement_propulsion == null:
					available_scenes.append_array(movements.filter(func(x): return x.type == "propulsion"))
		if len(available_scenes) == 0:
			return ""

		var to_add = available_scenes.pick_random()
		movement = to_add.instantiate()


	add_child(movement)

	if movement.movement_type == "propulsion":
		movement_propulsion = movement
	else:
		movement_modifiers.append(movement)

	print("  added movement: ", movement.movement_name, ", type: ", movement.movement_type)
	return movement.movement_type

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
		return type

	var to_remove = components.pick_random()
	to_remove.queue_free.call_deferred()
	if to_remove == movement_propulsion:
		movement_propulsion = null
	else:
		movement_modifiers.erase(to_remove)
	
	print("  removed movement: ", to_remove.name)
	return to_remove.type

func _swap_movement(type:="any", component: Movement = null) -> String:
	type = _remove_movement(type)
	_add_movement(type, component)

	return type

func _on_end_of_life() -> void:
	reproduction_chance = 1 - (Globals.enemy_counts[type] / float(max_count * reproduction_count))
	super._on_end_of_life()

func _on_timer_timeout() -> void:
	pass # handle end of life in cooldown
