extends Node

#This script holds the 'truth' of which items are in the players inventory.

signal inventory_updated #Used to alert the UI that the inventory changed

var inventory = [
	{ "name": "carrot", "is_owned": true, "texture": preload("res://assets/placeholder/placeholder_carrot.png"), "target_name": "Testobject" },
	{ "name": "spooky_guy", "is_owned": true, "texture": preload("res://player/p_down.png") },
	{ "name": "godot_guy", "is_owned": true, "texture": preload("res://icon.svg") },
	{ "name": "placeholder", "is_owned": false, "texture": preload("res://icon.svg") },
	{ "name": "placeholder2", "is_owned": false, "texture": preload("res://icon.svg") },
	{ "name": "placeholder3", "is_owned": true, "texture": preload("res://icon.svg") },
	{ "name": "placeholder4", "is_owned": false, "texture": preload("res://icon.svg") },
	{ "name": "placeholder5", "is_owned": true, "texture": preload("res://icon.svg") },
]
var current_slot_index: int = 0 #Keeps track of which item the player last selected, across scene change.


func collect_item(item_name: String):
	for i in range(len(inventory)):
		if item_name == inventory[i]["name"]:
			inventory[i]["is_owned"] = true
			inventory_updated.emit()
			return
	print("Warning: Couldn't add item: ", item_name)


func remove_item(item_name: String):
	for i in range(len(inventory)):
		if item_name == inventory[i]["name"]:
			inventory[i]["is_owned"] = false
			inventory_updated.emit()
			return
	print("Warning: Couldn't remove item: ", item_name)


func get_held_item():
	if current_slot_index > inventory.size() or current_slot_index < 0:
		print("Tried to get item at unknown index")
		return null
	return inventory[current_slot_index]


func update_current_slot_index(i: int):
	current_slot_index = i
