extends Node2D

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite
@onready var blocker = %Lock
@onready var close_trigger = $CloseTrigger
@onready var dialogue = load("res://dialogues/items.dialogue")

var gate_opened = false
var exitable = true
var win_conditions_met = false

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.play("close")
	blocker.disabled = false
	_check_win_conditions()

func _on_interact():
	_check_win_conditions()
	if win_conditions_met:
		return
	DialogueManager.show_dialogue_balloon(dialogue, "gate_reject")

# Player has key and activates gate with key
func activate():
	_check_win_conditions()
	if win_conditions_met:
		return
	if not gate_opened and exitable:
		SoundManager.play_random_pitch("gate_latch", -2, 1.5)
		sprite.play("open")
		gate_opened = true
		blocker.disabled = true
		Globals.is_home = true
		print("is home set to true")
		DialogueManager.show_dialogue_balloon(dialogue, "key_activate")


func _on_close_trigger_body_entered(body: Node2D) -> void:
	_check_win_conditions()
	if body.is_in_group("player") and win_conditions_met:
		print("Win conditions met, should open the gate.")
		SoundManager.play_random_pitch("gate_latch", -2, 1.5)
		sprite.play("open")
		gate_opened = true
		blocker.call_deferred("set", "disabled", true)
		Globals.is_home = true
		print("is home set to true")
		DialogueManager.show_dialogue_balloon(dialogue, "key_activate")
		return
	if body.is_in_group("player") and gate_opened: # or use group check if you preferprint("Player passed through gate — closing it")
		SoundManager.play_random_pitch("gate_latch", -2, 1)
		sprite.play("close")
		gate_opened = false
		blocker.call_deferred("set", "disabled", false)
		exitable = false # player cannot open gate before tasks are done
		# TODO: set exitable to true when tasks are done
		# TODO: set exitable to true when key is found, and false before key is found


func _check_win_conditions():
	if InventoryManager.get_owned_items_count() >= 6:
		win_conditions_met = true
	else:
		win_conditions_met = false
