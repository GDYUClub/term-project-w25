extends Node2D

var scroll_speed:float = 125
const SCROLL_LIMIT:float = -7500

func _process(delta:float) -> void:
	%ScrollContent.position.y -= scroll_speed * delta 
	if %ScrollContent.position.y <= SCROLL_LIMIT:
		get_tree().change_scene_to_file("res://src/main/new_main_menu.tscn")
	if Input.is_action_pressed("pickup_panel"):	
		scroll_speed = 1000
	else:
		scroll_speed = 125
