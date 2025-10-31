extends Node2D


@onready var player = $Player

func _ready():
	SoundManager.play_music("ambience_forest")
	if SceneManager.prev_scene == "forest_pathB":
		player.position = Vector2(424.0, 851)
		player.set_sprite_direction("up")
	elif SceneManager.prev_scene == "main_hall":
		player.position = Vector2(702.0, -100)

# TODO: script for gate and blocker toggle so player cannot return before tasks are done
