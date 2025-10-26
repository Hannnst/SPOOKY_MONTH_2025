extends Node

var move_enabled = true

##---Player Inventory---##
var collectible_items = [] #List of strings: All collectible items in game
var player_inventory = ["carrot", "godot_guy"] #List of strings: Collected items

signal inventory_updated

func collect_inventory_item(item_name : String):
	if item_name in collectible_items:
		if item_name not in player_inventory:
			player_inventory.append(item_name)
			inventory_updated.emit()
		else:
			print("Warning: Player collected this twice", item_name)
	else: 
		print("Warning: Attempted to collect non-existant item, ", item_name)	
	pass
