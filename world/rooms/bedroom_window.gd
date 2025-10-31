extends Node2D
# This is an informal interface for objects. Consider using classes in the future but avoiding complexity for now

#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea
@onready var dialogue = load("res://dialogues/items.dialogue")

@onready var animated_sprite = $Sprite2D

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	print("Interacting with:", self)
	DialogueManager.show_dialogue_balloon(dialogue, "bedroom_window_interact")
	await DialogueManager.dialogue_ended
	if Globals.window_closed == true:
		$Sprite2D.play("closed")
		await get_tree().create_timer(0.2).timeout
		if Globals.get_remaining("matches_collected") >= 1:
			DialogueManager.show_dialogue_balloon(dialogue, "matches_collect")
			InventoryManager.collect_item("matches")
			Globals.trigger_finite_event("matches_collected")
		
