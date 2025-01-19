extends Control
class_name ResultScreen

@onready var hover_sound: AudioStreamPlayer = $SfxMenuHover
@onready var select_sound: AudioStreamPlayer = $SfxMenuSelect
@onready var win_screen: Control = $WinScreen
@onready var lose_screen: Control = $LoseScreen
@onready var win_theme: AudioStreamPlayer = $FinalTheme
@onready var lose_theme: AudioStreamPlayer = $HellTheme

func _ready():
    if Globals.won:
        win_screen.visible = true
        lose_screen.visible = false
        win_theme.play()
    elif not Globals.won:
        win_screen.visible = false
        lose_screen.visible = true
        lose_theme.play()
    else:
        print("No game state??")

func _on_play_again_button_mouse_entered():
    hover_sound.play()

func _on_main_menu_button_mouse_entered():
    hover_sound.play()

func _on_main_menu_button_pressed():
    select_sound.play()
    get_tree().change_scene_to_file("res://scenes/MainMenu/main_menu.tscn")

func _on_play_again_button_pressed():
    select_sound.play()
    get_tree().change_scene_to_file("res://scenes/battle.tscn")
