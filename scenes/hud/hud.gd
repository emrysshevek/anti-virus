extends Control
class_name HUD

@export var health_label: Label
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var heaven_theme: AudioStreamPlayer = $BHEAVEN
@onready var hell_theme: AudioStreamPlayer = $BHELL
@onready var final_theme: AudioStreamPlayer = $FINAL

var minutes = 0
var time = 0.0

var player: Player
var has_player: bool
var currently_playing_theme: AudioStreamPlayer

func _ready():
	health_label = $Health
	currently_playing_theme = hell_theme
	currently_playing_theme.volume_db = 0.0
	currently_playing_theme.play()
	var player_node = get_tree().get_nodes_in_group("player")
	if player_node.size() > 0:
		player = get_tree().get_first_node_in_group("player")
		has_player = true
	else:
		print("no current player")
	progress_bar.max_value = Globals.countdown
	print(Globals.countdown)

func _process(_delta) -> void:
	var fraction_filled = progress_bar.value / progress_bar.max_value
	
	progress_bar.value += 1
	if fraction_filled < 0.45:
		if not hell_theme.playing:
			crossfade_tracks(currently_playing_theme, hell_theme, 2.0)
			currently_playing_theme = hell_theme
	elif fraction_filled < 0.75:
		if Globals.phase_one:
			Globals.phase_two = true
			Globals.phase_one = false
		if not heaven_theme.playing:
			crossfade_tracks(currently_playing_theme, heaven_theme, 2.0)
			currently_playing_theme = heaven_theme
	else:
		if not final_theme.playing:
			crossfade_tracks(currently_playing_theme, final_theme, 2.0)
			currently_playing_theme = final_theme
	if has_player:
		health_label.text = "Health: " + str(player.health)

func crossfade_tracks(old_player: AudioStreamPlayer, new_player: AudioStreamPlayer, duration := 2.0):
	new_player.volume_db = 0.0
	new_player.play()

	var tween_out = create_tween()
	tween_out.tween_property(old_player, "volume_db", 0.0, duration)
	
	var tween_in = create_tween()
	tween_in.tween_property(new_player, "volume_db", 0.0, duration)
	
