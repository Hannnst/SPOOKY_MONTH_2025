extends Node2D

@onready var player = $Player
@export var enemy_scene : PackedScene
@export var toy_scene : PackedScene
var enemy_instance

var dialogue = load("res://dialogues/music_room.dialogue")

func _ready():
	player.set_sprite_direction("left")
	%ScaryEvent/CollisionShape2D.disabled = true
	%ClearEvent/CollisionShape2D.disabled = true
	%ForgetfulTrigger/CollisionShape2D.disabled = true
	%Gate.disabled = true
	
	if Globals.get_remaining("piano_girl") > 0:
		$PianoGirl.play()
	else:
		$PianoGirl.queue_free()
		%AudioStreamPlayer2D.stop()
		%LampLight.enabled = false
		%CanvasModulate.color = Color(0.078, 0.074, 0.074)
	
	if Globals.get_remaining("spooky_piano_cleared") <= 0:
		%ScaryEvent.queue_free()
		%PianoClosed.show()
		
		#If the player beat the piano monster but forgot to pick up their toy
		if Globals.get_remaining("toy_collected") > 0:
			_spawn_toy()
	else:
		Globals.piano_closed = false


func _on_scary_event_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player.speed = 20
		SoundManager.play_music("spooky_piano")
		enemy_instance = enemy_scene.instantiate()
		enemy_instance.position = Vector2(250.0, 450)
		add_child(enemy_instance)

func _on_clear_event_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Globals.trigger_finite_event("spooky_piano_cleared")
		player.speed = 200
		SoundManager.stop_music()
		if enemy_instance: 
			enemy_instance.queue_free()
		%ScaryEvent.queue_free()
		%ClearEvent.queue_free()
		_spawn_toy()

func _spawn_toy():
	var toy_instance = toy_scene.instantiate()
	toy_instance.position = Vector2(820.0, 650)
	add_child(toy_instance)


func _on_forgetful_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		DialogueManager.show_dialogue_balloon(dialogue, "forgetful")
