extends Control
class_name MainMenu

#The sounds that player when the button is hovered over
func _on_start_button_mouse_entered():
    $MainMenuScreen/SfxMenuHover.play()

func _on_credits_button_mouse_entered():
    $MainMenuScreen/SfxMenuHover.play()

func _on_quit_button_mouse_entered():
    $MainMenuScreen/SfxMenuHover.play()

func _on_back_button_mouse_entered():
    $MainMenuScreen/SfxMenuHover.play()

func _on_confirm_button_mouse_entered():
    $MainMenuScreen/SfxMenuHover.play()

#The sounds that player when the button is pressed
func _on_start_button_pressed():
    $MainMenuScreen/SfxMenuSelect.play()
    get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_credits_button_pressed():
    $MainMenuScreen/SfxMenuSelect.play()
    $MainMenuScreen.visible = false
    $CreditsScreen.visible = true

func _on_quit_button_pressed():
    $MainMenuScreen/SfxMenuSelect.play()
    $MainMenuScreen.visible = false
    $QuitScreen.visible = true

func _on_confirm_quit_button_pressed():
    $MainMenuScreen/SfxMenuSelect.play()
    get_tree().quit()

func _on_back_button_pressed():
    $MainMenuScreen/SfxMenuSelect.play()
    $MainMenuScreen.visible = true
    $CreditsScreen.visible = false
    $QuitScreen.visible = false


