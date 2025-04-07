extends Node

var prev_event :InputEvent= null
func _input(event: InputEvent) -> void:
	if event.as_text() == "1":
		get_tree().change_scene_to_file("res://src/levels/tutorial/tutorial-1.tscn")
	elif event.as_text() == "2":
		get_tree().change_scene_to_file("res://src/levels/tutorial/tutorial-2.tscn")
	elif event.as_text() == "3":
		get_tree().change_scene_to_file("res://src/levels/2/level2-1-1.tscn")
	elif event.as_text() == "4":
		get_tree().change_scene_to_file("res://src/levels/2/level2-1-2.tscn")
	elif event.as_text() == "5":
		get_tree().change_scene_to_file("res://src/levels/2/level2-2.tscn")
