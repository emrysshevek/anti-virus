class_name EnemyState
extends State

const INIT := "Init"
const TARGET := "Target"
const MOVE := "Move"
const WINDUP := "Windup"
const ATTACK := "Attack"
const COOLDOWN := "Cooldown"

var entity: Enemy

func _ready() -> void:
	await owner.ready
	print(owner.name)
	entity = owner as Enemy
	print(entity)
	assert(entity != null, "The Enemy state type must be used only in the enemy scene. It needs the owner to be a enemy node.")
