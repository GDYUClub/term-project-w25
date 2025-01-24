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
		save.position = player.global_position
		if "puzzle_step" in game_level:
			save.puzzle_step = game_level.puzzle_step
		save.level = get_tree().current_scene.get_scene_file_path()
		save.write_savegame()
	# LOADS ALL VARIABLES
	# Can kinda save position as well but do we really need it?
	#player.global_position = save.position
	if "puzzle_step" in game_level:
		game_level.puzzle_step = save.puzzle_step
		game_level.load_puzzle_state()

	if get_tree().current_scene.get_scene_file_path() != save.level: # CHANGE LEVEL FROM MENU
		get_tree().call_deferred("change_scene_to_file", save.level)

# SAVES GAME
func save_game(scene_path: String) -> void:
	# Can kinda save position as well but do we really need it?
	#save.position = player.global_position
	save.level = scene_path
	if "puzzle_step" in game_level:
		save.puzzle_step = game_level.puzzle_step
	save.write_savegame()
