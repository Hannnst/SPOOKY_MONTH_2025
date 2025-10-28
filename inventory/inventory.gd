extends CanvasLayer

@onready var slot_container = $PanelContainer/MarginContainer/HBoxContainer
var slots = []
var current_index = 0


func _ready():
	slots = slot_container.get_children()
		
	_load_inventory()
	
	_setup_focus()
	#_update_focus()

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
		button.focus_exited.connect(_on_slot_unfocused)
		
	current_index = InventoryManager.current_slot_index
	slots[current_index].get_node("Button").grab_focus()

func _on_slot_unfocused():
	current_index = -1
	InventoryManager.current_slot_index = -1

func _on_slot_focus(i: int):
	current_index = i
	InventoryManager.current_slot_index = i

func _unhandled_input(event):
	if event.is_action_pressed("use_item"):
		_try_use_item()
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_focus_next"): 
		if not get_viewport().gui_get_focus_owner():
			slots[0].get_node("Button").grab_focus()
			get_viewport().set_input_as_handled()
			return

func _try_use_item():
	var index = InventoryManager.current_slot_index
	if index < 0 or index >= InventoryManager.inventory.size():
		print("Tried to use item, but no slot selected.")
		return

	var selected = InventoryManager.inventory[index]
	if not selected["is_owned"]:
		print("Player tried to use item, but wasn't holding anything")
		return
	
	print("Player used item:", selected["name"])
	
	#TODO: Handle logic for using the selected item. Many ways to solve this so we can decide later
	#When we know what the game is all about!
	
