extends Node2D

@onready var player = $Player

func _ready():
	SoundManager.play_music("ambience_house")
	player.set_sprite_direction("up")
