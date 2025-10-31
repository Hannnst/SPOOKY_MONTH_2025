extends Node2D

func _ready():
	$Player.set_sprite_direction("up")
	SoundManager.play_music("ambience_horror", -10)
