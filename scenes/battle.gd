extends Node2D
class_name Battle

@export var upgrade_scene: PackedScene 
@export var spawn_area_width: float = 800.0
@export var spawn_area_height: float = 600.0

# Reference to the Timer node
@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
	randomize()
	spawn_timer.start()


func _on_spawn_timer_timeout():
	spawn_random_upgrade()

func spawn_random_upgrade():
	if not upgrade_scene:
		print("No upgrade_scene assigned!")
		return

	# Instantiate the Upgrade scene
	var upgrade_instance = upgrade_scene.instantiate() as Upgrade

	# Randomly pick an enum value (0..5), matching your possible_upgrades
	var random_index = int(randi() % 6)
	upgrade_instance.upgrade_name = random_index

	# Position the upgrade at a random location within the spawn area
	var random_pos = Vector2(
		randf_range(-spawn_area_width, spawn_area_width),
		randf_range(-spawn_area_height, spawn_area_height)
	)
	upgrade_instance.position = random_pos

	# Add the upgrade to this Battle scene
	add_child(upgrade_instance)

	print("Spawned upgrade:", upgrade_instance.upgrade_name, "at", random_pos, "\n\n\n\n")
