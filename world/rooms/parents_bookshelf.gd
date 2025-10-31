extends StaticBody2D
# This is an informal interface for objects. Consider using classes in the future but avoiding complexity for now

#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea
@onready var dialogue = load("res://dialogues/items.dialogue")


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	if Globals.get_remaining("vinyl_collected") <= 0:
			%BookShelfArea.disabled = false
	else:
		%BookShelfArea.disabled = true
func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	print("Interacting with:", self)
	
	DialogueManager.show_dialogue_balloon(dialogue, "parents_bookscase_interact")
