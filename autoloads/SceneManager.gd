extends Node

var scenes = {
	"testA": "res://world/test_scenes/test_room_A.tscn",
	"testB": "res://world/test_scenes/test_room_B.tscn"
}

func get_scene_path(scene_name):
	if scene_name in scenes:
		return scenes[scene_name]
	else:
		print("SceneManager: Scene not present in action level list:" % scene_name)

func change_scene(scene_name: String):
	var scene_path = get_scene_path(scene_name)
	if scene_path:
		TransitionScreen.transition()
		await TransitionScreen.transition_finished
		get_tree().change_scene_to_file(scene_path)
		Globals.move_enabled = true
