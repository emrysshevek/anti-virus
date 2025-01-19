class_name Player
extends Entity

#export variables that we can change from the editor, player data is typically grabbed from 
@export var player_data: PlayerData
@export var texture: Sprite2D
@export var hitbox: CollisionShape2D
@export var analyzation_area: Area2D
@export var slowing_area: Area2D
@export var player_damage: float = 5
@export var platelet_scene: PackedScene
@export var max_upgrades: Array = [false, false, false, false]
@export var slow_rate = 2.0

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
@onready var slow_timer: Timer = $slow_area/slow_timer

var input = Vector2.ZERO
var platelet_instance : Platelets


func _ready():
	$player_animation.play("idle")
	$analyzation_area/analyze_animation.play("idle")
	$slow_area/slow_animation.play("idle")
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
		health += 1

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
	
	#if Input.is_action_just_pressed("shield") and shield:
	#	shield_ability.activate_shield()
		
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


#Analyzation Area
func _on_analyzation_area_body_entered(body:Node2D) -> void:
	print(body)
	if body.is_in_group("enemy"):
		analyzation_timer.start()
		print("Analyzing object: ", body.name)

func _on_analyzation_area_body_exited(body:Node2D) -> void:
	if body.is_in_group("enemy"):
		analyzation_timer.stop()
		print("Stopped analyzing object: ", body.name)

func _on_analyzation_timer_timeout():
	var overlapping = analyzation_area.get_overlapping_bodies()
	for body in overlapping:
		if body.is_in_group("enemy"):
			print("Player entered DamageSquare!")
			body.analyze(1)
			print("Analyzing ", body.name, ", current analyzation time: ", body.current_analyzation_time)	
#End Analyzation Area

func aquire_platelet():
	if not unlock_platelet:
		platelet_instance = platelet_scene.instantiate()
		call_deferred("add_child", platelet_instance)
		#add_child(platelet_instance)
		print("You unlocked the platelet!")
		unlock_platelet = true
	elif platelet_instance and unlock_platelet:
		platelet_instance.call_deferred("pickup_platelets")
		#platelet_instance.pickup_platelets()
		print("You already unlocked the platelet!")

func aquire_dash():
	if not dash_ability.is_unlocked:
		dash_ability.is_unlocked = true
		print("you've unlocked the dash ability!")
	else:
		print("You already unlocked the dash ability!")

func _on_slow_area_body_entered(body:Node2D):
	print(body)
	if body.is_in_group("enemy"):
		body.slow(slow_rate)
		print(str(body.name) + " entered the slowing range")

func _on_slow_area_body_exited(body:Node2D):
	if body.is_in_group("enemy"):
		body.slow(slow_rate)
		print(str(body.name) + " exited the slowing range")