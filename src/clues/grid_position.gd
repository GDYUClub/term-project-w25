class_name GridBox
extends Area2D

var id: int
var scroll_id: int
var current_clue: CluePanel
var correct_panel: bool = false
@onready var numberLabel = $NumberLabel
@onready var hover : Sprite2D = $Hover
static var all_grid_positions: Array[GridBox]


#Sets the current panel to p and checks if its the right panel
func set_active_panel(p: CluePanel) -> void:
	if p == null:
		return
	current_clue = p
	correct_panel = (current_clue.clue.correct_panel == id)
	print(correct_panel)


func clear_active_panel() -> void:
	current_clue = null
	correct_panel = false


func _ready() -> void:
	connect("mouse_entered", on_hover)
	connect("mouse_exited", off_hover)


func check_placement(p: CluePanel, gb: GridBox) -> void:
	if gb == self:
		set_active_panel(p)
	elif p == current_clue:
		clear_active_panel()

func on_hover():
	hover.visible = true
func off_hover():
	hover.visible = false
