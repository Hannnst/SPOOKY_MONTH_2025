extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

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
	elif direction.x < 0 and direction.y == 0:
		animated_sprite.play("left")
	elif direction.y > 0 and direction.x == 0:
		animated_sprite.play("down")
	elif direction.y < 0 and direction.x == 0:
		animated_sprite.play("up")
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
