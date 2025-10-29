extends StaticBody2D

# This is an informal interfrace for objects. Consider using classes in the future but avoiding complexity for now
@onready var sprite = $Sprite2D

#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea
@onready var dialogue = load("res://dialogues/items.dialogue")


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	print("Interacting with:", self)
	print("Sprite is:", sprite)
	sprite.flip_v = !sprite.flip_v
	DialogueManager.show_dialogue_balloon(dialogue, "skull_collect")
	InventoryManager.collect_item("skull")


func activate():
	DialogueManager.show_dialogue_balloon(dialogue, "skull_activate")
