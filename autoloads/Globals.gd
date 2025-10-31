extends Node

#Certain variables and functions should be easily available from anywhere in the game
#These variables can go here.

var move_enabled = true
var can_pause = true
var is_home = false

#Global tracker for events you want to only occur a limited amount of times.
#First two entries are just examples.
var finite_events = {
	"piano_girl": 1,
	"spooky_piano_cleared": 1,
	"toy_collected": 1,
	"vinyl_collected": 1,
	"cd_collected": 1,
	"vinyl_played": 1,
}

var piano_closed = false


#This function checks if the event exists in the finite_events dictionary:
#If the event exists, reduce the event by 1 and return true.
#Else: print a warning and return false
func trigger_finite_event(event_name) -> bool:
	if event_name in finite_events:
		if finite_events[event_name] < 1:
			print("Event '", event_name, " has been exhausted. Nothing should happen")
			return false
		else:
			print("Event ", event_name, " reduced by 1")
			finite_events[event_name] -= 1
		return true
	else:
		print("Warning: Tried to trigger unknown event in Globals: ", event_name)
		return false


func get_remaining(event_name):
	if event_name in finite_events:
		return finite_events[event_name]
	else:
		print("Warning: Tried to check unknown event in Globals: ", event_name)
		return -1
