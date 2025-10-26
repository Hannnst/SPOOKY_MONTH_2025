extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_box = %InteractionBox

var speed = 200 # pixels per second


func _physics_process(delta):
	var direction = Vector2.ZERO
	if Globals.move_enabled:
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1
	#kalkulerer sterkeste retning, prioriterer første bruker-input:
	# TODO: ikke hardkodede tallverdier
	if direction.x > 0 and direction.y == 0:
		animated_sprite.play("right")
		interaction_box.position = Vector2(150, -90)
	elif direction.x < 0 and direction.y == 0:
		animated_sprite.play("left")
		interaction_box.position = Vector2(-150, -90)
	elif direction.y > 0 and direction.x == 0:
		animated_sprite.play("down")
		interaction_box.position = Vector2(0, 20)
	elif direction.y < 0 and direction.x == 0:
		animated_sprite.play("up")
		interaction_box.position = Vector2(0, -300)
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	# TODO: hurtbox


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
	if body.is_in_group("enemies"):
		die()
