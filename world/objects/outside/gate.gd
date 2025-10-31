extends Node2D

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite
@onready var blocker = %Lock
@onready var close_trigger = $CloseTrigger
@onready var dialogue = load("res://dialogues/items.dialogue")

var gate_opened = false
var exitable = true


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.play("close")
	blocker.disabled = false


func _on_interact():
	if not gate_opened and exitable:
		SoundManager.play_random_pitch("gate_latch", -2, 1.5)
		sprite.play("open")
		gate_opened = true
		blocker.disabled = true
	else:
		DialogueManager.show_dialogue_balloon(dialogue, "gate_reject")


func _on_close_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and gate_opened: # or use group check if you preferprint("Player passed through gate — closing it")
		SoundManager.play_random_pitch("gate_latch", -2, 1)
		sprite.play("close")
		gate_opened = false
		blocker.call_deferred("set", "disabled", false)
		exitable = false # player cannot open gate before tasks are done
		# TODO: set exitable to true when tasks are done
		# TODO: set exitable to true when key is found, and false before key is found
