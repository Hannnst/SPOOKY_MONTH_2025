extends StaticBody2D


@onready var sprite = $Sprite2D

#Dette må legges til på alle interactable objekter:
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	#Unik kode for hva som skjer når en spiller interacter
	print("Interacting with:", self)
	print("Sprite is:", sprite)
	sprite.flip_v = !sprite.flip_v
