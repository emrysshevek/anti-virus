class_name Neurotoxin
extends Enemy

@export var bubble_interval := Vector2(1, 2)

@onready var bubble_timer = $BubbleTimer

func _ready() -> void:
	super._ready()
	moveable = true

	bubble_timer.wait_time = randf_range(bubble_interval.x, bubble_interval.y)
	bubble_timer.start()

func _on_bubble_timer_timeout() -> void:
	var bubble = preload("res://entities/attacks/slow_attack.tscn").instantiate()
	get_parent().add_child(bubble)
	bubble.global_position = global_position

	print("emitted a bubble")
	
	bubble_timer.wait_time = randf_range(bubble_interval.x, bubble_interval.y)
	bubble_timer.start()

		
