class_name Player
extends CharacterBody2D

#export variables that we can change from the editor, player data is typically grabbed from 
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
const move_snap = 2

@onready var dash_ability: DashAbility = $DashAbility
@onready var shield_ability: ShieldAbility = $ShieldAbility

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
	if Input.is_action_just_pressed("unlock") and not dash_ability.is_unlocked :
		dash_ability.is_unlocked = true
		print("you've unlocked the dash ability!")

func _process(_delta):
	#give i frames to dash
	if dash_ability.is_dashing:
		hitbox.disabled = true
		#print("i")
	else: 
		hitbox.disabled = false
		#print("x")

func get_input() -> Vector2:
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	# Flip the sprite depending on horizontal direction
	if input.x < 0: 
		texture.flip_h = true
	elif input.x > 0:
		texture.flip_h = false

	return input.normalized()

#function to handle the player movemnt - this will get processed in the physics process and checks the get_input function 
#to determine where the player is trying to move 
func player_movement(delta):
	var input_dir = get_input()
	if dash_ability.can_dash() and Input.is_action_just_pressed("dash") and dash_ability.is_unlocked:
		var dash_dir = input_dir if input_dir != Vector2.ZERO else velocity.normalized()
		dash_ability.start_dash(dash_dir)
	
	if Input.is_action_just_pressed("shield"):
		shield_ability.activate_shield()
		
	velocity = dash_ability.update_dash(delta,velocity)

	if not dash_ability.is_dashing:
		if input_dir == Vector2.ZERO:
			velocity = velocity.move_toward(Vector2.ZERO, friction * move_snap * delta)
		else:
			velocity = velocity.move_toward(input_dir * max_speed, accel * delta)

	move_and_slide()

#function to take damage from enemy
func take_damage(damage):
	health -= damage
	print("Current Health: " + str(health))
	# if health <= 0:
	# 	die()

func die():
	queue_free()

func _on_analyzation_area_area_entered(area: Area2D):
	var overlapping_areas = analyzation_area.get_overlapping_areas()
	if area.is_in_group("walls") and not $hurtbox:
		print("Analyzing wall: ", area.name)

	for loc in overlapping_areas:
		if loc in analyzation_area.get_overlapping_areas() and not $hurtbox:
			print("Already analyzing wall: ", loc.name)
