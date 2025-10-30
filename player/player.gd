extends CharacterBody2D

@onready var interaction_box = %InteractionBox
@onready var animation_player = $AnimationPlayer

var speed = 200 # pixels per second
var last_direction = "down"


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
	rotate_flashlight()


func set_sprite_direction(dir_string: String):
	if dir_string in ["up", "down", "left", "right"]:
		last_direction = dir_string
	else:
		print("Warning: tried to set unknown direction")


func rotate_flashlight():
	var rotation_speed := 1.0 # Higher = faster rotation
	var delta = 0.1
	if velocity != Vector2.ZERO:
		var target_rotation = velocity.angle() - PI / 2
		%Node2DFlashlight.rotation = lerp_angle(%Node2DFlashlight.rotation, target_rotation, rotation_speed * delta)
		$EnemySensor/CollisionShape2D.rotation = lerp_angle($EnemySensor/CollisionShape2D.rotation, target_rotation, rotation_speed * delta)


func die():
	# TODO: randomly show one of many end-screen strings
	print("You'll never get your happy ending")

	# Stop movement
	velocity = Vector2.ZERO
	set_physics_process(false)

	# Freeze enemy damage while game over
	collision_layer = 0
	collision_mask = 0

	# Show Game Over or reload scene
	get_tree().reload_current_scene()


func _on_hurt_box_body_entered(body: Node2D):
	if body.is_in_group("enemies") and body.triggered:
		die()
