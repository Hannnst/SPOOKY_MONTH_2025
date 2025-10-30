extends Control


func _on_check_box_start_game_pressed() -> void:
	SceneManager.change_scene("testB")


func _on_check_button_exit_game_pressed() -> void:
	get_tree().quit()


func _on_play_focus_entered() -> void:
	focus_button(play_button)

func _on_play_focus_exited() -> void:
	unfocus_button(play_button)

func _on_credits_focus_entered() -> void:
	focus_button(credits_button)
	
func _on_credits_focus_exited() -> void:
	unfocus_button(credits_button)

func _on_quit_focus_entered() -> void:
	focus_button(quit_button)
	
func _on_quit_focus_exited() -> void:
	unfocus_button(quit_button)

func focus_button(button):
	button.add_theme_font_size_override("font_size", 64)
	#Scuffed solution but godot needs time to think lmao
	await get_tree().process_frame
	await get_tree().process_frame
	icon.position = button.get_global_transform_with_canvas().origin + Vector2(0, (button.size.y / 2))
	icon.position += icon_offset

func unfocus_button(button):
	button.add_theme_font_size_override("font_size", 48)
