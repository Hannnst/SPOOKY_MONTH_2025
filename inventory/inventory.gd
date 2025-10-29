extends CanvasLayer

@onready var slot_container = $PanelContainer/MarginContainer/HBoxContainer
var slots = []
var current_index = 0
@onready var use_item_icon = $UseItemIcon
@onready var dialogue = load("res://dialogues/items.dialogue")


func _ready():
	slots = slot_container.get_children()
	_load_inventory()
	_setup_focus()
	InventoryManager.inventory_updated.connect(_load_inventory)


#Update UI to match reality: Fetches the inventory and relevant data from global InventoryManager
func _load_inventory():
	slots = slot_container.get_children()
	var inventory = InventoryManager.inventory

	for i in range(slots.size()):
		var texture_rect = slots[i].get_node("TextureRect")

		if i < inventory.size():
			var item = inventory[i]
			if item["is_owned"]:
				texture_rect.texture = item["texture"]
			else:
				texture_rect.texture = null
		else:
			texture_rect.texture = null


func _setup_focus():
	for i in range(slots.size()):
		var button = slots[i].get_node("Button")

		# Setup wrap-around focus neighbors
		var left = (i - 1 + slots.size()) % slots.size()
		var right = (i + 1) % slots.size()

		button.focus_neighbor_left = slots[left].get_node("Button").get_path()
		button.focus_neighbor_right = slots[right].get_node("Button").get_path()

		# Connect focus event to update selection
		button.focus_entered.connect(_on_slot_focus.bind(i))

	current_index = InventoryManager.current_slot_index
	slots[current_index].get_node("Button").grab_focus()


func _on_slot_focus(i: int):
	InventoryManager.update_current_slot_index(i)
	var selected = InventoryManager.get_held_item()
	if selected.is_owned:
		use_item_icon.show()
	else:
		use_item_icon.hide()


func _unhandled_input(event):
	if event.is_action_pressed("use_item"):
		_try_use_item()
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_focus_next"):
		if not get_viewport().gui_get_focus_owner():
			slots[0].get_node("Button").grab_focus()
			get_viewport().set_input_as_handled()
			return


func _try_use_item():
	var inventory_item = InventoryManager.get_held_item()
	if not inventory_item:
		print("Tried to use item, but no slot selected.")
		return

	if not inventory_item.is_owned:
		print("Player tried to use item, but wasn't holding anything")
		return

	if not inventory_item.has("target_name"):
		print("item has no target_name, therefore should print flavortext")
		# TODO: null point excepting handling
		DialogueManager.show_dialogue_balloon(dialogue, inventory_item.name + "_use")
		return

	var target_object = InteractionManager._get_closest_object()
	if (target_object and inventory_item):
		if inventory_item.target_name == target_object.name:
			target_object.activate() # activates a node's attached script
	else:
		#TODO: inventory_item.activate()
		print("Player tried to use item, but wasn't near any related target items")

		DialogueManager.show_dialogue_balloon(dialogue, inventory_item.name + "_use")
		return
