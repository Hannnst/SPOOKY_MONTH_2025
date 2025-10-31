extends Area2D

@export var target_scene_name = "outside_house"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.change_scene(target_scene_name)
