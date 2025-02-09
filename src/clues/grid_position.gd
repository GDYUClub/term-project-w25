class_name GridBox
extends Area2D

var id:int
var current_clue:CluePanel
var correct_panel: bool = false
@onready var numberLabel = $NumberLabel
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
	pass

func check_placement(p: CluePanel, gb: GridBox) -> void:
	if gb == self:
		set_active_panel(p)
	elif p == current_clue:
		clear_active_panel()
