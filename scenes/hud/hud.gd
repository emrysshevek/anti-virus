extends Control
class_name HUD

@export var health_label: Label
@onready var progress_bar: ProgressBar = $ProgressBar

var player: Player
var has_player: bool

func _ready():
    health_label = $Health
    var player_node = get_tree().get_nodes_in_group("player")
    if player_node.size() > 0:
        player = get_tree().get_first_node_in_group("player")
        has_player = true
    else:
        print("no current player")

func _process(_delta):
    progress_bar.value += 0.05
    if has_player:
        health_label.text = "Heath: " + str(player.health)
    