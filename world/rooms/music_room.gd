extends Node2D


func _ready():
	if Globals.get_remaining("piano_girl") > 0:
		$PianoGirl.play()
	else:
		$PianoGirl.queue_free()
		%AudioStreamPlayer2D.stop()
		%LampLight.enabled = false
		
	if Globals.get_remaining("close_piano") > 0:
		%PianoClosed.hide()
	else:
		%PianoClosed.show()
