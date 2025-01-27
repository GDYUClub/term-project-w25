class_name SaveGame
extends Resource

static var resFilePath = "res://src/resources/saveFile.tres"
static var resUserPath = "user://src/resources/saveFile.tres"

static var SAVE_GAME_PATH = resUserPath if Engine.is_editor_hint() else resFilePath

# VARIABLES THAT NEED TO BE SAVED
@export var position = Vector2.ZERO
@export var level = "res://src/main/level_1.tscn"
@export var puzzle_step = 0

# WRITES THE SAVE FILE
func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

# LOADS THE SAVE FILE
static func load_savegame() -> Resource:
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)

# CHECKS IF SAVE FILE EXISTS
static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)
