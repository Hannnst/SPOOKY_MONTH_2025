extends Node2D

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	$Sprite.play("close")


func _on_interact():
	$Sprite.play("open")
