extends Area2D

# This function is used to set the global direction variable
func _ready() -> void:
	Global.direction = "metadata/Direction"

# This functions puts the player in the next frame
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_position($NewFrame.global_position)

## To use the function: 
# drag the Frame scene into the main scene
# Right click the frame scene and select Editable Children
# Move the "NewFrame" cursor to where you want player to be put in the new frame
# put the collision box where the exit of the previous scene will be
# Select the "Frame" Object and change the Direction number for the next scene
# See src/Global.gd for direction reference
