extends Area2D

@export var target_scene_name = "outside_house"
@export var dialogue_resource = load("res://dialogues/exit_dialogues.dialogue")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.change_scene(target_scene_name)
