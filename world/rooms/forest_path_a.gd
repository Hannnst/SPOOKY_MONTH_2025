extends Node2D

@onready var player = $Player
var spawn_from_outside = Vector2(2134, 602)

@onready var dialogue = preload("res://dialogues/messages.dialogue")


func _ready():
	_set_player_spawn()
	
func _set_player_spawn():
	match SceneManager.prev_scene:
		"forest_pathB":
			player.set_sprite_direction("left")
			player.position = spawn_from_outside
		_:
			player.set_sprite_direction("right")
			#Spawn set by editor.


func _on_if_game_complete_body_entered(body: Node2D) -> void:
	#TODO: Check if the game is complete to play the ending!
	if body.is_in_group("player"):
		DialogueManager.show_dialogue_balloon(dialogue, "no_going_back")
	
