extends Node2D

func _ready():
	#Make sure to put the player in the correct position, 
	#corresponding their previous location.
	pass


func _on_exitpath_b_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.change_scene("testA")
