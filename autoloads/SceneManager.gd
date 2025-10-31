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
	#Kan også legge til cutscene scener her
}

#Variables used for finding initial player position certain scenes
var current_scene = ""
var prev_scene = "main_menu"

func get_scene_path(scene_name):
	if scene_name in scenes:
		return scenes[scene_name]
	else:
		print("SceneManager: Scene not present in action level list: ", scene_name)


func change_scene(scene_name: String):
	var scene_path = get_scene_path(scene_name)
	if scene_path:
		#Update records:
		prev_scene = current_scene
		current_scene = scene_name
		
		#transition:
		TransitionScreen.transition()
		await TransitionScreen.transition_finished
		get_tree().change_scene_to_file(scene_path)
		Globals.move_enabled = true
		DialogueManager.can_show_dialogue = true
		InteractionManager.icon_enabled = true
		
		print("previous scene: ", prev_scene)
		print("current scene: ", current_scene)

func reload_from_death(scene_name: String):
	var scene_path = get_scene_path(scene_name)
	if scene_path:
		#Update records:
		prev_scene = current_scene
		current_scene = scene_name
		get_tree().change_scene_to_file(scene_path)
		Globals.move_enabled = true
		DialogueManager.can_show_dialogue = true
		InteractionManager.icon_enabled = true
		
		print("previous scene: ", prev_scene)
		print("current scene: ", current_scene)

func player_death():
	TransitionScreen.player_death_animation()
