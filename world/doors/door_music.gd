extends Node2D

# This is an informal interfrace for objects. Consider using classes in the future but avoiding complexity for now

#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	SceneManager.change_scene("music_room")
