extends Node

@export var save: Node

func _on_load_pressed() -> void: # LOAD ALREADY FILE
	save.create_or_load_save()

func _on_new_pressed() -> void: # DELETE OLD FILE
	DirAccess.remove_absolute("res://src/resources/saveFile.tres")
	get_tree().change_scene_to_file("res://src/main/save_game_example/example_save_level_1.tscn")
