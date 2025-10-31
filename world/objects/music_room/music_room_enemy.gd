extends CharacterBody2D

@export var chase_speed: float = 45

var direction := Vector2.ZERO
var triggered := true

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $Sprite2D
@onready var base_sprite_position = Vector2(0, -30)


func _ready():
	pass
	# Reset timers

func _physics_process(delta):
	var direction_to_player = (player.global_position - global_position).normalized()
	var shake_strength := 4.0 # pixels

	velocity = direction_to_player * chase_speed
	animated_sprite.position = base_sprite_position + Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength),
	)
	move_and_slide()
