extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("fade_in")
	


func play_ending_dialogue():
	var dialogue = load("res://dialogues/ending_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "ending")
	await DialogueManager.dialogue_ended
	return_to_main()

func return_to_main():
	SceneManager.change_scene("main_menu")
