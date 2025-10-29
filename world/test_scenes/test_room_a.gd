extends Node2D

func _ready():
	SoundManager.play_music("test_music")

func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneManager.change_scene("testB")
