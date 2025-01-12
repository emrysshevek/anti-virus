extends Node2D

@onready var spawner: Spawner = $Spawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if spawner != null:
		spawner.spawn(1000, .1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
