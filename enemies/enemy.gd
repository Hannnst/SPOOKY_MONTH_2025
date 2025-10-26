extends CharacterBody2D

@export var speed: float = 80.0
@export var change_dir_time: float = 1.5

var direction := Vector2.ZERO
var timer := 0.0

# TODO: timer for how long enemy has been in contact with interaction box for light from player, initiating and deactivating seeking state


func _ready():
	randomize()
	_pick_new_direction()


func _physics_process(delta):
	timer -= delta
	if timer <= 0.0:
		_pick_new_direction()

	velocity = direction * speed
	move_and_slide()


func _pick_new_direction():
	timer = change_dir_time

	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()
