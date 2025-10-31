extends Node

#The SoundManager allows music to play across scene transitions, and
#makes sure too many sound effects don't overlap at once.

#To use the SoundManager from anywhere in the game, use the following functions!

# playSFX(sfx_name, volume, pitch)
# - Plays a sound effect. Make sure it is listed in the sound_effects dict!
# - For example playSFX("explosion", 0.8, 1.2)

# play_random_pitch(sfx_name, volume, pitch_spread)
# - Plays a sound effect but picks a random pitch every time for variation.
# - For example play_random_pitch("explosion", 1.0, 0.05)

# play_music(song_name, volume)
# - Starts playing a new song. Note: Only one song can play at a time.

# Tip: If you want to add ambient sounds (i.e. wind sounds)
# please add an AudioPlayer node manually to your scene instead of using SoundManager

var voices := 15

var sound_effects = {
	"explosion" : preload("res://sounds/sound_effects/test-Explosion7.wav"),
	"8bit_hit" : preload("res://sounds/sound_effects/Hit 1 - Sound effects Pack 2.wav"),
	"8bit_hit2" : preload("res://sounds/sound_effects/Hit 2 - Sound effects Pack 2.wav"),
	"menu_select" : preload("res://sounds/sound_effects/menu_select.mp3"),
	"menu_confirm" : preload("res://sounds/sound_effects/menu_confirm.wav"),
	"paper_rustle" : preload("res://sounds/sound_effects/paper_rustle.mp3"),
	"step_sound" : preload("res://sounds/sound_effects/Hit 2 - Sound effects Pack 2.wav"),
	"explosion": preload("res://sounds/sound_effects/test-Explosion7.wav"),
	"8bit_hit": preload("res://sounds/sound_effects/Hit 1 - Sound effects Pack 2.wav"),
	"8bit_hit2": preload("res://sounds/sound_effects/Hit 2 - Sound effects Pack 2.wav"),
	"menu_select": preload("res://sounds/sound_effects/menu_select.mp3"),
	"menu_confirm": preload("res://sounds/sound_effects/menu_confirm.wav"),
	"paper_rustle": preload("res://sounds/sound_effects/paper_rustle.mp3"),
	"heartbeat": preload("res://sounds/sound_effects/actions/heartbeat-thudding.mp3"),
	"heartbeat_fast": preload("res://sounds/sound_effects/actions/heartbeat-tense.mp3"),
	"heartbeat_single": preload("res://sounds/sound_effects/actions/heartbeat-single.mp3"),
}

var music = {
	"test_music": preload("res://sounds/music/test-beach_ambience.mp3"),
}

var sfx_players = []
var next = 0
var sfx_bus = "SFX"

var music_player
var music_bus = "Music"
var fade_tween: Tween = null # New Godot 4 tween


func _ready():
	randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS
	#Default to master if they can't find the bus
	if AudioServer.get_bus_index(sfx_bus) == -1:
		sfx_bus = "Master"
	if AudioServer.get_bus_index(music_bus) == -1:
		music_bus = "Master"

	#SFX players
	for i in range(voices):
		var player = AudioStreamPlayer.new()
		player.bus = sfx_bus
		add_child(player)
		sfx_players.append(player)

	#Single Music player (Can add one more if we want overlapping transitions or whatever)
	music_player = AudioStreamPlayer.new()
	music_player.bus = music_bus
	add_child(music_player)


### ----- Play Sound Effects! ----- ###
func playSFX(sound_effect: String, volume_db := 0.0, pitch_scale := 1.0) -> void:
	var sfx = sound_effects[sound_effect]
	if sfx == null:
		print("AudioManager: Couldn't find requested sound effect, ", sound_effect)
		return

	var sfx_player: AudioStreamPlayer = sfx_players[next]
	next = (next + 1) % sfx_players.size()
	sfx_player.stop()
	sfx_player.stream = sfx
	sfx_player.volume_db = volume_db
	sfx_player.pitch_scale = pitch_scale
	sfx_player.play()


func play_random_pitch(sound_effect: String, volume_db := 0.0, pitch_spread := 0.04) -> void:
	var pitch = 1.0 + randf_range(-pitch_spread, pitch_spread)
	playSFX(sound_effect, volume_db, pitch)


func stop_all_sfx() -> void:
	for sfx_player in sfx_players:
		sfx_player.stop()


### ----- Play music ----- ###
func play_music(track: String, volume_db := 0.0):
	var song = music[track]
	if song == null:
		return

	_kill_fade()

	music_player.stop()
	music_player.stream = song
	music_player.volume_db = volume_db
	music_player.play()
	print("volume", music_player.volume_db)
	print("is_playing", music_player.playing)


func stop_music() -> void:
	_kill_fade()
	music_player.stop()


func fade_out_music(duration := 1.0) -> void:
	if not music_player or not music_player.playing:
		return

	_kill_fade() #Avoid overlapping tweens

	fade_tween = get_tree().create_tween()
	fade_tween.tween_property(music_player, "volume_db", -80.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	fade_tween.connect("finished", Callable(self, "_on_fade_done"))


func _kill_fade() -> void:
	if fade_tween != null and fade_tween.is_valid():
		fade_tween.kill() # Tween cleanup


func _on_fade_done() -> void:
	_kill_fade()
