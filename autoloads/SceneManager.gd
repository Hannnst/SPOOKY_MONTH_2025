extends Node

var scenes = {
	"main_menu": "res://ui/main_menu.tscn",
	"forest_pathA": "res://world/rooms/forest_pathA.tscn",
	"forest_pathB": "res://world/rooms/forest_pathB.tscn",
	"main_hall": "res://world/rooms/main_hall.tscn",
	"bathroom": "res://world/rooms/bathroom.tscn",
	"bedroom": "res://world/rooms/bedroom.tscn",
	"master_bedroom": "res://world/rooms/master_bedroom.tscn",
	"kitchen": "res://world/rooms/kitchen.tscn",
	"music_room": "res://world/rooms/music_room.tscn",
	"outside_house": "res://world/rooms/outside_house.tscn",
	"testA": "res://world/test_scenes/test_room_A.tscn",
	"testB": "res://world/test_scenes/test_room_B.tscn",
	"ending": "res://world/rooms/ending.tscn",
	#Kan også legge til cutscene scener her
}

#Variables used for finding initial player position certain scenes
var current_scene = "main_menu"
var prev_scene = "main_menu"
var is_loading = false

func get_scene_path(scene_name):
	if scene_name in scenes:
		return scenes[scene_name]
	else:
		print("SceneManager: Scene not present in action level list: ", scene_name)

# --- MAIN CHANGE: async load version ---
func change_scene(scene_name: String) -> void:
	if is_loading:
		return
	var scene_path = get_scene_path(scene_name)
	if scene_path == "":
		return

	prev_scene = current_scene
	current_scene = scene_name
	is_loading = true

	# fade to black (your TransitionScreen handles this)
	TransitionScreen.transition()
	await TransitionScreen.transition_finished

	await _load_scene_async(scene_path)

	# give the engine one more frame to settle after change
	await get_tree().process_frame
	TransitionScreen.fade_in_animation()
	Globals.move_enabled = true
	DialogueManager.can_show_dialogue = true
	InteractionManager.icon_enabled = true

	is_loading = false
	print("previous scene:", prev_scene)
	print("current scene:", current_scene)


# --- fallback for respawn / quick reload ---
func reload_from_death(scene_name: String) -> void:
	if is_loading:
		return
	var scene_path = get_scene_path(scene_name)
	if scene_path == "":
		return
	is_loading = true

	prev_scene = current_scene
	current_scene = scene_name

	await _load_scene_async(scene_path)
	await get_tree().process_frame

	Globals.move_enabled = true
	DialogueManager.can_show_dialogue = true
	InteractionManager.icon_enabled = true

	is_loading = false
	print("reloaded scene:", current_scene)


# --- the async loader itself ---
func _load_scene_async(scene_path: String) -> void:
	var err := ResourceLoader.load_threaded_request(scene_path)
	if err != OK:
		push_error("Failed to start async load for %s" % scene_path)
		return

	var progress: Array = []
	while true:
		var status := ResourceLoader.load_threaded_get_status(scene_path, progress)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var packed := ResourceLoader.load_threaded_get(scene_path)
			if packed and packed is PackedScene:
				get_tree().change_scene_to_packed(packed)
			break
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Scene load failed: %s" % scene_path)
			break
		await get_tree().process_frame

func player_death():
	SoundManager.stop_music()
	TransitionScreen.player_death_animation()
