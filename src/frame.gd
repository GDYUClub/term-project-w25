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
@export_range(.1,1) var jane_scale:float
@export var arrow_dir:ARROW_DIRECTIONS

@onready var arrowArea := $ArrowNotif
@onready var arrow := $Sprite2D

func _ready() -> void:
	arrow.visible = false
	rotate_arrow()
	body_entered.connect(_on_body_entered)
	arrowArea.body_entered.connect(_toggle_arrow)
	arrowArea.body_exited.connect(_toggle_arrow)

func rotate_arrow():
	match arrow_dir:
		ARROW_DIRECTIONS.UP:
			arrow.rotate(0)
		ARROW_DIRECTIONS.DOWN:
			arrow.rotate(deg_to_rad(180))
		ARROW_DIRECTIONS.RIGHT:
			arrow.rotate(deg_to_rad(90))
		ARROW_DIRECTIONS.LEFT:
			arrow.rotate(deg_to_rad(-90))


# This functions puts the player in the next frame
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_position($NewFrame.global_position)
		body._change_move_type(move_type)
		body.change_scale(jane_scale)

func _toggle_arrow(body:Node2D):
	if body.is_in_group("player"):
		arrow.visible = !arrow.visible
