extends Node
# IDK WHAT TO NAME THIS CAN RENAME PLS
# EXPORTS
@export var player : CharacterBody2D
@export var game_level : Node2D

# VARIABLES
var save : SaveGame


# LOAD OR SAVE GAME
func create_or_load_save() -> void:
	if SaveGame.save_exists(): # LOAD GAME
		save = SaveGame.load_savegame()
	else: # MAKE NEW FILE
		save = SaveGame.new()
		save_game(get_tree().current_scene.get_scene_file_path())
		save.write_savegame()

	load_game(get_tree().current_scene.get_scene_file_path())

# SAVES GAME
func save_game(scene_path: String) -> void:
	save.level = scene_path

	if get_tree().current_scene.get_scene_file_path() == scene_path:
		save.position = player.global_position

	if game_level.has_method("puzzle_step"):
		save.puzzle_step = game_level.puzzle_step

	save.write_savegame()

func load_game(scene_path: String) -> void:
	if save.level == scene_path:
		player.global_position = save.position
	
	if game_level.has_method("puzzle_step"):
		game_level.puzzle_step = save.puzzle_step
		game_level.load_puzzle_state()

	if save.level != scene_path: # CHANGE LEVEL FROM MENU
		get_tree().call_deferred("change_scene_to_file", save.level)

	
