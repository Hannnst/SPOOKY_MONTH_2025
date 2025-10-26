extends CanvasLayer

@onready var slot_container = $Panel/MarginContainer/HBoxContainer
var current_index = 0

var inventory = []
var textures = {
	"carrot" : "res://assets/placeholder/placeholder_carrot.png",
	"godot_guy" : "res://icon.svg",
	#TODO: Add more item textures :)
}

func _ready():
	_load_inventory()
	_update_focus()

func _load_inventory():
	#Fetches the inventory from the Global script
	inventory = Globals.player_inventory.duplicate(true)
	var slots = slot_container.get_children()
	if inventory.size() > slots.size():
		print("Warning: Not enough inventory slots for all inventory items :s")
	for i in range(slots.size()):
		var slot = slots[i]
		var texture_rect = slot.get_node("TextureRect")
		if i < inventory.size():
			var path = _get_texture(inventory[i])
			var item_texture = load(path)
			texture_rect.texture = item_texture

func _get_texture(item_name):
	if item_name in textures.keys():
		return textures[item_name]
	else:
		print("Item texture not found in inventory.tscn: ", item_name)

func _update_focus():
	pass
