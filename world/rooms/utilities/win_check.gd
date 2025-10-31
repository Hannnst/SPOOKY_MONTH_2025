extends Area2D

@export var target_scene_name = "main_menu"
var win_conditions_met = false

func _ready():
	_check_win_conditions()
	
func _on_body_entered(body: Node2D) -> void:
	_check_win_conditions()
	if body.is_in_group("player") and win_conditions_met:
		SceneManager.change_scene(target_scene_name)


func _check_win_conditions():
	if InventoryManager.get_owned_items_count() >= 6:
		win_conditions_met = true
	else:
		win_conditions_met = false
