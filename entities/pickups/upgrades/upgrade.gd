extends Area2D
class_name Upgrade

enum possible_upgrades {DASH, SHIELD, SPEED, HEALTH, DAMAGE, PLATELET, PLATELETBOOST, SHOT, SHOTRATE, SLOW}

@export var upgrade_name : possible_upgrades
#@export var upgrade_type: PackedScene
@export var texture: Sprite2D

func _on_body_entered(body:Node2D):
    if body is Player:
        print("Aquired:" + str(upgrade_name))
        aquire_upgrade(body)
        queue_free()

func _ready():
    if upgrade_name == possible_upgrades.DASH:
        texture.modulate = Color.GREEN
    elif upgrade_name == possible_upgrades.SHIELD:
        texture.modulate = Color.ORANGE
    elif upgrade_name == possible_upgrades.SPEED:
        texture.modulate = Color.YELLOW
    elif upgrade_name == possible_upgrades.HEALTH:
        texture.modulate = Color.RED
    elif upgrade_name == possible_upgrades.DAMAGE:
        texture.modulate = Color.ORANGE
    elif upgrade_name == possible_upgrades.PLATELET:
        texture.modulate = Color.BLUE
    elif upgrade_name == possible_upgrades.PLATELETBOOST:
        texture.modulate = Color.PURPLE
    elif upgrade_name == possible_upgrades.SHOT:
        texture.modulate = Color.GRAY
    elif upgrade_name == possible_upgrades.SHOTRATE:
        texture.modulate = Color.HOT_PINK
    elif upgrade_name == possible_upgrades.SLOW:
        texture.modulate = Color.LIGHT_BLUE
    else:
        texture.modulate = Color.WHITE

func aquire_upgrade(player: Player):
    if upgrade_name == possible_upgrades.DASH:
        player.dash_ability.is_unlocked = true
    elif upgrade_name == possible_upgrades.SHIELD:
        player.shield_ability.is_unlocked = true
    elif upgrade_name == possible_upgrades.SPEED:
        if player.max_speed <= 800:
            player.max_speed *= 1.2
        else:
            player.max_speed = 800
    elif upgrade_name == possible_upgrades.HEALTH:
        player.health += 5
    elif upgrade_name == possible_upgrades.DAMAGE:
        player.player_damage += 2 
    elif upgrade_name == possible_upgrades.PLATELET:
        player.aquire_platelet()
    elif upgrade_name == possible_upgrades.PLATELETBOOST:
        player.platelet_instance.boost_speed()
    elif upgrade_name == possible_upgrades.SHOT:
        player.aquire_shot()
    elif upgrade_name == possible_upgrades.SHOTRATE:
        player.boost_shot()
    elif upgrade_name == possible_upgrades.SLOW:
        player.aquire_slow()
    else:
        print("No upgrade_type specified for:", upgrade_name)
