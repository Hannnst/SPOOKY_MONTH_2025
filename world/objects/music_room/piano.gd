extends StaticBody2D

# This is an informal interface for objects. Consider using classes in the future but avoiding complexity for now
#Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea
@onready var dialogue = load("res://dialogues/music_room.dialogue")
var piano_closed = false

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	print("Interacting with:", self)
	if Globals.trigger_finite_event("piano_girl"):
		%LampLight.enabled = false
		%AudioStreamPlayer2D.stop()
		%PianoGirl.queue_free()
		%CanvasModulate.color = Color(0.078, 0.074, 0.074)
		%ForgetfulTrigger/CollisionShape2D.disabled = false
		%Gate.disabled = false
	elif Globals.piano_closed == false:
		DialogueManager.show_dialogue_balloon(dialogue, "piano")
		await DialogueManager.dialogue_ended
		await get_tree().process_frame
		print("Current piano state (closed is): ", Globals.piano_closed)
			#Player can update this value in dialogue, hence the second check:
		if Globals.piano_closed == true:
			%ForgetfulTrigger/CollisionShape2D.disabled = true
			%Gate.disabled = true
			%PianoClosed.show()
			print("Spooky loud noise??")
			print("remaining spooky event cleared: ", Globals.get_remaining("spooky_piano_cleared"))
			if Globals.get_remaining("spooky_piano_cleared") > 0:
				%ScaryEvent/CollisionShape2D.disabled = false
				%ClearEvent/CollisionShape2D.disabled = false
			else:
				%ForgetfulTrigger/CollisionShape2D.disabled = false
				%Gate.disabled = false
	else:
		DialogueManager.show_dialogue_balloon(dialogue, "piano_closed")
