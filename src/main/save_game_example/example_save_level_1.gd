extends Node2D

@export var save : Node
var puzzle_step : int = 0

func _ready() -> void:
	save.create_or_load_save()
	save.save_game(get_tree().current_scene.get_scene_file_path()) # SAVES CURRENT SCENE
	
func _on_area_2d_body_entered(body: Node2D) -> void: # MOVING TO NEXT LEVEL
	# has to pre save the level path before loading
	save.save_game("res://src/main/save_game_example/example_save_level_2.tscn")
	save.load_game(get_tree().current_scene.get_scene_file_path()) # just to swap scenes

func _on_area_2d_2_body_entered(body: Node2D) -> void: # PUZZLE COMPLETION
	$puzzle/ColorRect.visible = true
	puzzle_step += 1 # one puzzle done yay
	save.save_game(get_tree().current_scene.get_scene_file_path())

func load_puzzle_state() -> void:
	match puzzle_step:
		1:
			$puzzle/ColorRect.visible = true
		2:
			# Load the second puzzle state
			pass
		# Add more puzzle steps as needed
		_:
			# Handle unexpected puzzle steps
			pass
