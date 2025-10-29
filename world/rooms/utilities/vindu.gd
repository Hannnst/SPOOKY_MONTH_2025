extends Sprite2D

# This is an informal interfrace for objects. Consider using classes in the future but avoiding complexity for now
#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	print("Interacting with:", self)
	
	var dialogue = load("res://dialogues/music_room.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "vindu")


func activate():
	# TODO: piano test activate function
	print(self.name, " says pling plong :-)")
