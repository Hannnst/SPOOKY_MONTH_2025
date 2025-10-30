extends Node2D

# This is an informal interface for objects. Consider using classes in the future but avoiding complexity for now

# This must be added to all interactable objects:
@onready var interaction_area = $InteractionArea
@export var target_scene_name = "main_hall"


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	SceneManager.change_scene(target_scene_name)
