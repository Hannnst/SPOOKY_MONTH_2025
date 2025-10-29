extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")
@onready var icon = $Icon
var icon_offset = Vector2(-100, -100)

var active_areas = []
var can_interact = true
var enable_icon = true


func _ready():
	icon.hide()
	$AnimationPlayer.play("bobbing")


func register_area(area: Area2D):
	print("registered area: ", area.get_parent().name)
	active_areas.push_back(area)


func unregister_area(area: Area2D):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		icon.global_position = active_areas[0].global_position
		icon.global_position += icon_offset
		if enable_icon:
			icon.show()
	else:
		icon.hide()


func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event):
	if event.is_action_pressed("ui_accept") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			icon.hide()
			await active_areas[0].interact.call()
			can_interact = true


func _get_closest_object():
	if active_areas.size() < 1:
		return null
	return active_areas[0].get_parent()
