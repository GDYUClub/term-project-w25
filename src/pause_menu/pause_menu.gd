extends Control

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_toggle()

# Toggles the pausing of the scene tree and the visibility of the pause menu
# The pause menu is unaffected because it is set to process_mode = always
func pause_toggle():  
	var tree = get_tree()
	tree.paused = not tree.paused
	visible = not visible

func _on_button_pressed() -> void:
	pause_toggle()
