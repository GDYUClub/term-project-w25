extends Area2D

# This function is used to set the global direction variable
	
enum MOVETYPES {
	TOP_DOWN,
	SIDE_SCROLLER,
}
enum ARROW_DIRECTIONS{
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

@export var move_type:MOVETYPES
@export var jane_scale:int
@export var arrow_dir:ARROW_DIRECTIONS
func _ready() -> void:
	body_entered.connect(_on_body_entered)

# This functions puts the player in the next frame
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_position($NewFrame.global_position)
		body._change_move_type(move_type)

## To use the function: 
# drag the Frame scene into the main scene
# Right click the frame scene and select Editable Children
# Move the "NewFrame" cursor to where you want player to be put in the new frame
# put the collision box where the exit of the previous scene will be
# Select the "Frame" Object and change the Direction number for the next scene
# See src/Global.gd for direction reference
