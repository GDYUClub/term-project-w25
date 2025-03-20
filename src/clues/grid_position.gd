class_name GridBox
extends Area2D

var id: int
var scroll_id: int
var current_clue: CluePanel = null
var correct_panel: bool = false
@onready var numberLabel = $NumberLabel
@onready var hover : Sprite2D = $Hover
static var all_grid_positions: Array[GridBox]


#Sets the current panel to p and checks if its the right panel
func set_active_panel(p: CluePanel) -> void:
	if p == null:
		return
	
	if current_clue == null:
		# If no current panel, simply set this one
		current_clue = p
		correct_panel = (current_clue.clue.correct_panel == id)
		print(current_clue.clue.correct_panel == id, id)


func clear_active_panel() -> void:
	if current_clue != null:
		current_clue = null
		correct_panel = false
	print("clear!")


func _ready() -> void:
	connect("mouse_entered", on_hover)
	connect("mouse_exited", off_hover)

func on_hover():
	hover.visible = true
func off_hover():
	hover.visible = false
