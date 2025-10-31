extends Node2D

# This is an informal interface for objects. Consider using classes in the future but avoiding complexity for now
@onready var sprite = $Sprite2D

#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea
@onready var dialogue = load("res://dialogues/items.dialogue")


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	if Globals.get_remaining("toy_collected") <= 0:
		queue_free()

func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	# for consideration: await sprite.play("test")
	DialogueManager.show_dialogue_balloon(dialogue, "toy_collect")
	var ended_dialogue = await DialogueManager.dialogue_ended
	if (dialogue == ended_dialogue):
		Globals.trigger_finite_event("toy_collected")
		InventoryManager.collect_item("toy")
		queue_free() # remove self from scene when collected

#The notebook is special: No activate function.
