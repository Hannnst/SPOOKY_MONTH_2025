extends Node

#This script holds the 'truth' of which items are in the players inventory.

signal inventory_updated #Used to alert the UI that the inventory changed
signal focus_returned

var inventory = [
	{ "name": "notebook", "is_owned": false, "texture": preload("res://assets/items/lapp-icon.png") },
	{ "name": "key", "is_owned": false, "texture": preload("res://world/objects/outside/key.webp"), "target_name": "Gate" },
	{ "name": "toy", "is_owned": false, "texture": preload("res://assets/items/tamagotchi.webp") },
	{ "name": "skull", "is_owned": false, "texture": preload("res://assets/items/skull_front.webp"), "target_name": "Grave" },
	{ "name": "vinyl", "is_owned": false, "texture": preload("res://assets/furniture/vinyl.webp"), "target_name": "VinylPlayer" },
	{ "name": "placeholder3", "is_owned": true, "texture": preload("res://icon.svg") },
]
var current_slot_index: int = 0 #Keeps track of which item the player last selected, across scene change.

var upgraded_items = {
	"cd": { "name": "cd", "is_owned": true, "texture": preload("res://assets/items/cd.png") },
	"gum": { "name": "gum", "is_owned": true, "texture": preload("res://world/objects/gum.webp") },
}


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


func upgrade_item(from: String, to: String):
	for i in range(len(inventory)):
		if inventory[i]["name"] == from:
			if to in upgraded_items:
				inventory[i] = upgraded_items[to]
				inventory_updated.emit()
				return
			else:
				print("Warning: Tried to upgrade item to non existant entry")
				return
	print("Warning: Tried to upgrade item that doesn't exist")


func get_held_item():
	if current_slot_index > inventory.size() or current_slot_index < 0:
		print("Tried to get item at unknown index")
		return null
	return inventory[current_slot_index]


func update_current_slot_index(i: int):
	current_slot_index = i


func toggle_notebook():
	pass


func is_item_owned(item_name):
	for item in inventory:
		if item["name"] == item_name:
			return item["is_owned"]
	return false
