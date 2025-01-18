class_name Bacteriophage
extends Enemy

@export var far_speed := 50
@export var near_speed := 100
@export var hover_range := Vector2(100, 150)

@onready var target: Node2D = $Target
@onready var spawner: Spawner = $Spawner