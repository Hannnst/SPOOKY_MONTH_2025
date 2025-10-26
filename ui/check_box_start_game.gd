extends CheckBox


func _on_toggled(_toggled_on: bool) -> void:
	SceneManager.change_scene("testB")
