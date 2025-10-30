extends Node2D

@onready var play_button = %Play
@onready var credits_button = %Credits
@onready var quit_button = %Quit
@onready var icon = $Icon

var icon_offset = Vector2(300, 0)

func _ready():
	play_button.grab_focus()


func _on_play_focus_entered() -> void:
	_focus_button(play_button)

func _on_play_focus_exited() -> void:
	play_button.add_theme_font_size_override("font_size", 48)

func _on_credits_focus_entered() -> void:
	_focus_button(credits_button)
	
func _on_credits_focus_exited() -> void:
	credits_button.add_theme_font_size_override("font_size", 48)

func _on_quit_focus_entered() -> void:
	_focus_button(quit_button)
	
func _on_quit_focus_exited() -> void:
	quit_button.add_theme_font_size_override("font_size", 48)

func _focus_button(button):
	button.add_theme_font_size_override("font_size", 64)
	#Scuffed solution but godot needs time to think lmao
	await get_tree().process_frame
	await get_tree().process_frame
	icon.position = button.get_global_transform_with_canvas().origin + Vector2(0, (button.size.y / 2))
	icon.position += icon_offset
