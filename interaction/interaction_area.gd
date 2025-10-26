extends Area2D

#Denne kan overskrives av objectet vi putter InteractionArea inn i - men er i utgangspunktet tom.
var interact: Callable = func():
	pass
	
func _on_area_entered(area: Area2D) -> void:
	if area.name == "InteractionSensor":
		InteractionManager.register_area(self)


func _on_area_exited(area: Area2D) -> void:
	if area.name == "InteractionSensor":
		InteractionManager.unregister_area(self)
