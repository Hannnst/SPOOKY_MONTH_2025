extends Node2D

@onready var player = $Player

var spawn_from_outside = Vector2(612.0, -1046.0)
var spawn_from_A = Vector2(591.0, 704.0)

func _ready():
	_set_player_spawn()
	
	
func _set_player_spawn():
	match SceneManager.prev_scene:
		"forest_pathA":
			player.set_sprite_direction("up")
			player.position = spawn_from_A
		"outside_house":
			player.set_sprite_direction("down")
			player.position = spawn_from_outside
