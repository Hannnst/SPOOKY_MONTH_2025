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
		interaction_box.position = Vector2(0, -150)

	direction = direction.normalized()
	velocity = direction * speed

	move_and_slide()
	rotate_flashlight()


func rotate_flashlight():
	if velocity != Vector2.ZERO:
		%Node2DFlashlight.rotation = velocity.angle() - PI/2
