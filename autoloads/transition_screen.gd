extends CanvasLayer

signal transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

var death_sound = "8bit_hit" #hardcoded default
var all_death_sounds = ["8bit_hit", "8bit_hit2"]

func _ready():
	color_rect.visible = false

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
		transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
	elif anim_name == "player_death":
		SceneManager.reload_from_death(SceneManager.prev_scene)
		animation_player.play("fade_to_normal")
		color_rect.visible = false

func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")

func pick_random_death_sound():
	death_sound = all_death_sounds.pick_random()
	
func play_sound():
	if death_sound in SoundManager.sound_effects:
		SoundManager.playSFX(death_sound)

func player_death_animation():
	color_rect.visible = true
	animation_player.play("player_death")
