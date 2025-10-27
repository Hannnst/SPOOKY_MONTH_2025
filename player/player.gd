extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_box = %InteractionBox

var speed = 200 # pixels per second


func _physics_process(delta):
	var direction := Vector2.ZERO

	if Globals.move_enabled:
		direction = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"),
		)

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animated_sprite.play("right")
				interaction_box.position = Vector2(150, -90)
			else:
				animated_sprite.play("left")
				interaction_box.position = Vector2(-150, -90)
		else:
			if direction.y > 0:
				animated_sprite.play("down")
				interaction_box.position = Vector2(0, 20)
			else:
				animated_sprite.play("up")
				interaction_box.position = Vector2(0, -250)

	velocity = direction.normalized() * speed
	move_and_slide()
	rotate_flashlight()


func rotate_flashlight():
	if velocity != Vector2.ZERO:
		%Node2DFlashlight.rotation = velocity.angle() - PI/2


func die():
	SoundManager.play_random_pitch("explosion")
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
