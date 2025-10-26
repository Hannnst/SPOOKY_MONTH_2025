extends Node

#Certain variables and functions should be easily available from anywhere in the game
#These variables can go here.

var move_enabled = true


func play_random_animation():
	var sprites = $AnimationPlayer.get_animation_list()
	var random_sprite = sprites[randi() % sprites.size()]
	$AnimationPlayer.play(random_sprite)
