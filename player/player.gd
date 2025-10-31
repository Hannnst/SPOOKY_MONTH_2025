extends CharacterBody2D

@onready var interaction_box = %InteractionBox
@onready var animation_player = $AnimationPlayer

var speed = 200 # pixels per second
var last_direction = "down"
var dead = false


func _ready():
	animation_player.play("idle_down")
	%AnimatedLeg_back.play()
	%AnimatedLeg_front.play()
	%AnimatedArm_back.play()
	%AnimatedArm_back_dup.play()
	%AnimatedBody.play()
	%AnimatedArm_front.play()
	%AnimatedHead.play()


func _physics_process(delta):
	var direction := Vector2.ZERO

	if Globals.move_enabled:
		direction = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
		)

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				last_direction = "right"
				interaction_box.position = Vector2(60, -40)
			else:
				last_direction = "left"
				interaction_box.position = Vector2(-60, -40)
		else:
			if direction.y > 0:
				last_direction = "down"
				interaction_box.position = Vector2(0, 20)
			else:
				last_direction = "up"
				interaction_box.position = Vector2(0, -90)
		animation_player.play("walk_" + last_direction)
	else:
		animation_player.play("idle_" + last_direction)
	velocity = direction.normalized() * speed
	move_and_slide()
	rotate_flashlight(direction, delta)

	for body in $HurtBox.get_overlapping_bodies():
		if body.is_in_group("enemies") and body.triggered:
			if not dead:
				die()


func set_sprite_direction(dir_string: String):
	if dir_string in ["up", "down", "left", "right"]:
		last_direction = dir_string
		match dir_string:
			"right":
				%Node2DFlashlight.rotation = -90
			"left":
				%Node2DFlashlight.rotation = 90
			"up":
				%Node2DFlashlight.rotation = -180
			"down":
				%Node2DFlashlight.rotation = 0
	else:
		print("Warning: tried to set unknown direction")


func rotate_flashlight(direction, delta):
	var rotation_speed := 5.0 # Higher = faster rotation

	if direction == Vector2.ZERO:
		return # do nothing if not moving

	if direction != Vector2.ZERO:
		var target_rotation = direction.angle() - PI / 2
		%Node2DFlashlight.rotation = lerp_angle(%Node2DFlashlight.rotation, target_rotation, rotation_speed * delta)
		$EnemySensor/CollisionShape2D.rotation = lerp_angle($EnemySensor/CollisionShape2D.rotation, target_rotation, rotation_speed * delta)


func die():
	# TODO: randomly show one of many end-screen strings
	dead = true
	print("You'll never get your happy ending")

	# Stop movement
	Globals.move_enabled = false
	Globals.can_pause = false

	# Freeze enemy damage while game over
	collision_layer = 0
	collision_mask = 0

	# Show Game Over or reload scene
	SceneManager.player_death()


func play_step_sound():
	if SceneManager.current_scene.begins_with("forest_") or SceneManager.current_scene.begins_with("outside_"):
		SoundManager.play_random_pitch("step_sound_outside", -0.3, 0.1)
	else:
		SoundManager.play_random_pitch("step_sound", -0.3, 0.1)
