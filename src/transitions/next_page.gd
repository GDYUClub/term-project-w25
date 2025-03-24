extends Area2D

enum ARROW_DIRECTIONS{
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

@export var arrow_dir:ARROW_DIRECTIONS
@export var next_page:PackedScene
@onready var arrowArea := $ArrowNotif
@onready var arrow := $Sprite2D

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

func _ready() -> void:
	arrow.visible = false
	rotate_arrow()
	body_entered.connect(_on_body_entered)
	arrowArea.body_entered.connect(_toggle_arrow)
	arrowArea.body_exited.connect(_toggle_arrow)

# This functions puts the player in the next frame
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_packed(next_page)
		pass

func _toggle_arrow(body:Node2D):
	if body.is_in_group("player"):
		arrow.visible = !arrow.visible
