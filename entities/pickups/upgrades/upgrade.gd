extends Area2D
class_name Upgrade

enum possible_upgrades {DASH, SHIELD, SPEED, HEALTH, DAMAGE, PLATELET}

@export var upgrade_name : possible_upgrades
#@export var upgrade_type: PackedScene
@export var texture: Sprite2D

func _on_body_entered(body:Node2D):
    if body is Player:
        print("Aquired:" + str(upgrade_name))
        aquire_upgrade(body)
        queue_free()

func aquire_upgrade(player: Player):
    if upgrade_name == possible_upgrades.DASH:
        player.dash_ability.is_unlocked = true
    elif upgrade_name == possible_upgrades.SHIELD:
        player.shield_ability.is_unlocked = true
    elif upgrade_name == possible_upgrades.SPEED:
        player.max_speed *= 1.2
    elif upgrade_name == possible_upgrades.HEALTH:
        player.health += 5
    elif upgrade_name == possible_upgrades.DAMAGE:
        player.player_damage += 2 
    elif upgrade_name == possible_upgrades.PLATELET:
        player.aquire_platelet()
    else:
        print("No upgrade_type specified for:", upgrade_name)
