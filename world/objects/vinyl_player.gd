extends StaticBody2D
# This is an informal interface for objects. Consider using classes in the future but avoiding complexity for now
@onready var sprite = $Sprite2D

#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea
@onready var dialogue = load("res://dialogues/items.dialogue")


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	if Globals.get_remaining("vinyl_played") <= 0:
		%StatueEnemy.position = Vector2(3556.0, 950)


func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	print("Interacting with:", self)
	print("Sprite is:", sprite)
	DialogueManager.show_dialogue_balloon(dialogue, "vinyl_player_interact")


func activate():
	$AudioStreamPlayer2D.play()
	DialogueManager.show_dialogue_balloon(dialogue, "vinyl_player_activate")
	Globals.trigger_finite_event("vinyl_played")
	await DialogueManager.dialogue_ended
	InventoryManager.remove_item("vinyl")
	%StatueEnemy.position = Vector2(3556.0, 950)
