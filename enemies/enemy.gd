extends CharacterBody2D

@export var scene: PackedScene
@export var texture: Texture2D
@export var nickname: String = "bob"
@export var enemy_speed: float = 20.0


func _ready():
	var enemy_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = enemy_types.pick_random()
	$AnimatedSprite2D.play()


func _physics_process(delta):
	# Create a new instance of the enemy scene.
	var enemy = scene.instantiate()

	# Choose a random location on Path2D.
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	# Set the enemy's position to the random location.
	enemy.position = enemy_spawn_location.position

	# Set the enemy's direction perpendicular to the path direction.
	var direction = enemy_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction

	# Choose the velocity for the enemy.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)


func _on_detection_layer_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detection_layer_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
