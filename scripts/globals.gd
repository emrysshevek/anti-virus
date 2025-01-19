extends Node

@export var countdown = 22000
@export var current_countdown = 0
@export var phase_duration := 3 * 60.0 # Each subphase of phase 1 lasts three minutes 

@export var current_phase = 1

var phase_one: bool = true
var phase_two: bool = false
var total_elapsed_time = 0.0
var phase_elapsed_time = 0.0
var enemy_counts = {}

@onready var game_duration := phase_duration * 4

func _ready() -> void:
    for key in Enemy.EnemyType.values():
        enemy_counts[key] = 0

func _physics_process(delta: float) -> void:
    total_elapsed_time += delta
    phase_elapsed_time += delta

func game_time_ratio() -> float:
    return total_elapsed_time / game_duration

func phase_time_ratio() -> float:
    return phase_elapsed_time / phase_duration


