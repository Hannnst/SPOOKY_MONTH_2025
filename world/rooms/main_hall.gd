extends Node2D

@onready var player = $Player

@onready var door_bathroom = %DoorBathroom
@onready var door_masters = %DoorMasters
@onready var door_kitchen = %DoorKitchen
@onready var door_music = %DoorMusic
@onready var door_bedroom = %DoorBedroom

var player_spawn_offset = Vector2(0, 25)
var default_player_position: Vector2


func _ready():
	SoundManager.play_music("ambience_house")
	default_player_position = player.position
	_set_player_spawn()


func _set_player_spawn():
	var spawn_position = default_player_position
	match SceneManager.prev_scene:
		"bathroom":
			spawn_position = door_bathroom.global_position + player_spawn_offset
		"bedroom":
			spawn_position = door_bedroom.global_position + player_spawn_offset
		"master_bedroom":
			spawn_position = door_masters.global_position + player_spawn_offset
		"kitchen":
			spawn_position = door_kitchen.global_position + player_spawn_offset
		"music_room":
			spawn_position = door_music.global_position + player_spawn_offset
		"outside_house":
			print("Entered from outside")
			player.set_sprite_direction("up")
		_:
			print("Warning: Player entered house from unknown area")
			player.set_sprite_direction("up")
	player.position = spawn_position
