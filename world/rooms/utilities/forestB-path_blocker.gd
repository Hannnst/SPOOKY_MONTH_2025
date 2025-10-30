
extends CharacterBody2D

@onready var collision_left = $CollisionShapeLeft
@onready var collision_right = $CollisionShapeRight

var original_position_left: Vector2
var original_position_right: Vector2

@export var move_distance: float = 35.0
@export var move_time: float = 0.5

@onready var dialogue = preload("res://dialogues/messages.dialogue")
func _ready():
	original_position_right = collision_right.position
	original_position_left = collision_left.position
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)


func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		DialogueManager.show_dialogue_balloon(dialogue, "stay_on_the_path")

func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	Globals.move_enabled = false
	_move_collisions()


func _move_collisions():
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(collision_left, "position", original_position_left + Vector2(move_distance, 0), move_time)	
	tween2.tween_property(collision_right, "position", original_position_right + Vector2(-move_distance, 0), move_time)

	tween.finished.connect(_reset_collisions)
	tween2.finished.connect(_reset_collisions)
		
func _reset_collisions():
	Globals.move_enabled = true
	collision_right.position = original_position_right
	collision_left.position = original_position_left
