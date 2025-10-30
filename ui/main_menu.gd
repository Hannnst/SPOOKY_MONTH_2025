extends Control


func _on_check_box_start_game_pressed() -> void:
	SceneManager.change_scene("testB")


func _on_check_button_exit_game_pressed() -> void:
	get_tree().quit()
