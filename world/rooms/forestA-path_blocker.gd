extends CharacterBody2D

@onready var collision_top = $CollisionShapeTop
@onready var collision_bottom = $CollisionShapeBottom

var original_position_top
var original_position_bottom

var move_distance = 30
var move_time = 0.5

func _ready():
	original_position_top = collision_top.position
	original_position_bottom = collision_bottom.position
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)


func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var dialogue = load("res://dialogues/messages.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "stay_on_the_path")

func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	Globals.move_enabled = false
	_move_collisions()


func _move_collisions():
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(collision_top, "position", original_position_top + Vector2(0, move_distance), move_time)	
	tween2.tween_property(collision_bottom, "position", original_position_bottom + Vector2(0, -move_distance), move_time)

	tween.finished.connect(_reset_collisions)
	tween2.finished.connect(_reset_collisions)
		
func _reset_collisions():
	Globals.move_enabled = true
	collision_top.position = original_position_top
	collision_bottom.position = original_position_bottom
