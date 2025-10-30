extends CanvasLayer
@onready var resume_button = %Resume
@onready var exit_button = %Exit

@onready var icon = %Icon

# Hardcoded positions - dynamic layout calculation with control nodes was problematic
var position_A = Vector2(860.0, 325.0)
var position_B = Vector2(860.0, 400.0)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	icon.play()
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		visible = false
	else:
		if Globals.can_pause:
			get_tree().paused = true
			visible = true
			resume_button.grab_focus() # So player can immediately hit Enter/Confirm

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_scene("main_menu")



func focus_button(button):
	button.add_theme_font_size_override("font_size", 60)

func unfocus_button(button):
	button.add_theme_font_size_override("font_size", 48)


func _on_resume_focus_entered() -> void:
	icon.position = position_A
	focus_button(resume_button)

func _on_resume_focus_exited() -> void:
	unfocus_button(resume_button)

func _on_exit_focus_entered() -> void:
	focus_button(exit_button)
	icon.position = position_B

func _on_exit_focus_exited() -> void:
	unfocus_button(exit_button)
