class_name Player
extends Entity

#export variables that we can change from the editor, player data is typically grabbed from 
@export var player_data: PlayerData
@export var texture: Sprite2D
@export var hitbox: CollisionShape2D
@export var analyzation_area: Area2D
@export var player_damage: float = 5
@export var platelet_scene: PackedScene

var unlock_platelet: bool = false

#character variables that are inherit to the player class
var inventory: bool

const accel = 650
# const friction = 850

#move snap is to make the left, right, up, down movement more reactive, for faster reflexes
const move_snap = 2

@onready var dash_ability: DashAbility = $DashAbility
@onready var shield_ability: ShieldAbility = $ShieldAbility
@onready var analyzation_timer: Timer = $analyzation_area/analyzation_timer

var input = Vector2.ZERO

func _ready():
	$player_animation.play("idle")
	if player_data != null:
		health = player_data.health
		max_speed = player_data.speed * 20
		power = player_data.power
		position = player_data.position
		analyzation_timer.stop()
	print("health: ", health, " speed: ", player_data.speed, " power: ", power)

func _physics_process(delta):
	player_movement(delta)
	if Input.is_action_just_pressed("unlock"):
		aquire_dash()
		aquire_platelet()
		health += 1
		
	if Input.is_action_pressed("analyze"):
		analyzation_area.monitoring = true
	else: 
		analyzation_area.monitoring = false

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
# player health is discrete and every hit only counts for one
func take_damage(damage):
	super.take_damage(1)

func die():
	queue_free()

func _on_analyzation_timer_timeout():
	var overlapping_areas = analyzation_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area is Enemy:
			#area.health -= int(player_damage)
			area.take_damage(player_damage)
			print(str(area.name) + "'s health is now " + str(area.health))

func _on_analyzation_area_body_entered(body:Node2D) -> void:
	if body.is_in_group("enemy"):
		analyzation_timer.start()
		print("Analyzing object: ", body.name)

func _on_analyzation_area_body_exited(body:Node2D) -> void:
	if body.is_in_group("enemy"):
		analyzation_timer.stop()
		print("Stopped analyzing object: ", body.name)

func aquire_platelet():
	if not unlock_platelet:
		var platelet = platelet_scene.instantiate()
		add_child(platelet)
		print("You unlocked the platelet!")
		unlock_platelet = true
	else:
		print("You already unlocked the platelet!")

func aquire_dash():
	if not dash_ability.is_unlocked:
		dash_ability.is_unlocked = true
		print("you've unlocked the dash ability!")
	else:
		print("You already unlocked the dash ability!")
	