extends CharacterBody2D

class_name Player

#export variables that we can change from the editor, player data is typically grabbed from player_data.tres in the player folder.
@export var player_data: PlayerData
@export var texture: Sprite2D
@export var hitbox: CollisionShape2D
@export var analyzation_area: Area2D

#character variables that are inherit to the player class
var health: int = 10
var inventory: bool
var power: int = 5
var max_speed = 400
const accel = 650
const friction = 850

#move snap is to make the left, right, up, down movement more reactive, for faster reflexes
const move_snap: int = 2
var input = Vector2.ZERO

func _ready():
	$player_animation.play("idle")
	if player_data != null:
		health = player_data.health
		max_speed = player_data.speed * 20
		power = player_data.power
		position = player_data.position
	print("health: ", health, " speed: ", player_data.speed, " power: ", power)

func _physics_process(delta):
	player_movement(delta)

func get_input():
	if input.x < 0: 
		texture.flip_h = true
	elif input.x > 0:
		texture.flip_h = false

	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input.normalized()

#function to handle the player movemnt - this will get processed in the physics process and checks the get_input function 
#to determine where the player is trying to move 
func player_movement(delta):
	input = get_input()

	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta * move_snap)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	move_and_slide()

#function to take damage from enemy

func take_damage(damage):
	health -= damage
	print("Current Health: " + str(health))
	#if health <= 0:
	#	die()

#func _on_hurtbox_area_entered(_area:Area2D):
#	take_damage(10)

func die():
	queue_free()
	


func _on_analyzation_area_area_entered(area:Area2D):
	var overlapping_areas = analyzation_area.get_overlapping_areas()
	if area.is_in_group("walls") and not $hurtbox:
		print("Analyzing wall: ", area.name)

	for loc in overlapping_areas:
		if loc in analyzation_area.get_overlapping_areas() and not $hurtbox:
			print("Already analyzing wall: ", loc.name)
