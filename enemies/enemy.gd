extends CharacterBody2D

@export var speed: float = 80.0
@export var chase_speed: float = 100
@export var change_dir_time: float = 1.5
@export var trigger_time: float = 1.0
@export var cooldown_time: float = 3.0
@export var animation_frames: SpriteFrames

var direction := Vector2.ZERO
var direction_timer := 0.0
var triggered := false
var base_sprite_position := Vector2(0, -29)

@onready var exposure_timer := $ExposureTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var animated_sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var heartbeat = preload("res://sounds/sound_effects/actions/heartbeat-thudding.mp3")
@onready var heartbeat_fast = preload("res://sounds/sound_effects/actions/heartbeat-tense.mp3")


func _ready():
	if animation_frames:
		animated_sprite.sprite_frames = animation_frames
	else:
		animation_frames = animated_sprite.sprite_frames
	randomize()
	_pick_new_direction()
	# Reset timers
	exposure_timer.wait_time = trigger_time
	cooldown_timer.wait_time = cooldown_time


func _physics_process(delta):
	if triggered:
		_chase_player()
	else:
		direction_timer -= delta
		if direction_timer <= 0.0:
			_pick_new_direction()
		velocity = direction * speed
	move_and_slide()


func _pick_new_direction():
	direction_timer = change_dir_time
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()
	if direction.y < 0:
		animated_sprite.play("up")
	else:
		animated_sprite.play("down")


#  --------------- Functionality for exposure and triggering ------------
func _on_exposure_timer_timeout():
	cooldown_timer.wait_time = cooldown_time # reset timer
	triggered = true
	_play_sound(heartbeat_fast, true)


func _on_cooldown_timer_timeout():
	exposure_timer.wait_time = trigger_time # reset timer
	triggered = false
	$Sound.stop()


func _chase_player():
	var direction_to_player = (player.global_position - global_position).normalized()
	var shake_strength := 4.0 # pixels
	# TODO: check if it has animation called chase, play it, if not play "down"
	if animated_sprite.sprite_frames and "chase" in animated_sprite.sprite_frames.get_animation_names():
		animated_sprite.play("chase")
	else:
		animated_sprite.play("down")

	velocity = direction_to_player * chase_speed
	animated_sprite.position = base_sprite_position + Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength),
	)


func _on_trigger_area_area_entered(area: Area2D) -> void:
	if area.name == "EnemySensor":
		exposure_timer.start()
		_play_sound(heartbeat)


func _on_trigger_area_area_exited(area: Area2D) -> void:
	if area.name == "EnemySensor":
		exposure_timer.stop()
		cooldown_timer.start()
		if not triggered:
			$Sound.stop()


func _play_sound(sound, loop = false):
	$Sound.stop()
	$Sound.stream = sound
	if loop:
		$Sound.stream.loop = true
	$Sound.play()
