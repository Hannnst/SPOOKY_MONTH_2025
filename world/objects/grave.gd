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
	DialogueManager.show_dialogue_balloon(dialogue, "grave_interact")


# TODO: if player collides with grave, play dialogue for falling into game and reset/end game
func activate():
	DialogueManager.show_dialogue_balloon(dialogue, "grave_activate")
	InventoryManager.upgrade_item("skull", "gum")
	await DialogueManager.dialogue_ended
	DialogueManager.show_dialogue_balloon(dialogue, "gum_collect")
