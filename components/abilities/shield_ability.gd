extends Area2D
class_name ShieldAbility

@export var shield_cooldown := 1.0
@export var is_unlocked: bool = false

@onready var shield_timer = $shield_timer
@onready var shield_shape = $shield_shape
@onready var shield_art = $shield_art

var is_on_cooldown: bool = false


func _ready():
	shield_timer.one_shot = true
	shield_timer.wait_time = shield_cooldown
	shield_shape.disabled = true
	shield_art.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("shield") and is_unlocked:
		activate_shield()

func _on_area_entered(area:Area2D):
	if Globals.phase_one:
		if area is Attack:
			print("you destroyed a projectile!")
			area.queue_free()
	if Globals.phase_two:
		if area.is_in_group("enemy"):
			area.queue_free()
			print("kill this dude")

func activate_shield():
	if not is_on_cooldown:
		shield_shape.disabled = false
		shield_art.visible = true
		is_on_cooldown = true
		shield_timer.start()
		print("Activated")

func deactivate_shield():
	shield_shape.disabled = true
	shield_art.visible = false
	is_on_cooldown = false
	print("Deactivated")

func _on_shield_timer_timeout():
	deactivate_shield()

func _on_body_entered(body:Node2D):
	if Globals.phase_two:
		if body.is_in_group("enemy"):
			#body.take_damage(8)
			body.die()
			printt(body.name,"BIG DAMAGE BABY! " + str(body.health) + "!")