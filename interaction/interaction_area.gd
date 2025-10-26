extends Area2D

@export var area_size : Vector2 = Vector2(150,85)
@onready var collision_shape = $CollisionShape2D
#Denne kan overskrives av objectet vi putter InteractionArea inn i - men er i utgangspunktet tom.
var interact: Callable = func():
	pass

func _ready():
	pass
	#collision_shape.disabled = true
	
func _on_area_entered(area: Area2D) -> void:
	if area.name == "InteractionSensor":
		InteractionManager.register_area(self)


func _on_area_exited(area: Area2D) -> void:
	if area.name == "InteractionSensor":
		InteractionManager.unregister_area(self)
