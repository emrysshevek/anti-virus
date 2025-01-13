extends Node
class_name DashAbility

@export var dash_speed = 300
@export var dash_time = 0.5
@export var dash_cooldown = 3.0
@export var is_unlocked = false

var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var is_dashing = false
var dash_direction = Vector2.ZERO

func can_dash() -> bool:
    return not is_dashing and dash_cooldown_timer <= 0.0

func start_dash(direction:Vector2):
    is_dashing = true
    dash_direction = direction
    dash_timer = dash_time
    dash_cooldown_timer = dash_cooldown

func update_dash(delta:float, current_velocity:Vector2) -> Vector2:
    if dash_cooldown_timer > 0.0:
        dash_cooldown_timer -= delta

    if is_dashing:
        current_velocity = dash_direction * dash_speed
        dash_timer -= delta
        if dash_timer <= 0.0:
            print("You just finished dashing")
            is_dashing = false

    return current_velocity
