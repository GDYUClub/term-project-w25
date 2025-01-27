extends Node2D

@export var save : Node

func _ready() -> void:
	save.create_or_load_save()
	save.save_game(get_tree().current_scene.get_scene_file_path()) # SAVES CURRENT SCENE
