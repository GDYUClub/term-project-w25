class_name GridBox
extends Area2D

@export var desired_panel_name: String
var current_panel:CluePanel
var correct_panel: bool = false
static var all_grid_positions: Array[GridBox]

#Sets the current panel to p and checks if its the right panel
func set_active_panel(p: CluePanel) -> void:
	if p == null:
		return
	print(p.clue.name)
	current_panel = p
	#Check if it is the correct panel
	correct_panel = (desired_panel_name == current_panel.get_panel_name())

func clear_active_panel() -> void:
	current_panel = null
	correct_panel = false

func _ready() -> void:
	#all_grid_positions.push_back(self)
	#panel.notifier.placed.connect(check_placement.bind())
	pass

static func all_panels_correct() -> bool:
	for box in all_grid_positions:
		if box.correct_panel == false:
			return false
	return true

static func delete_grid() -> void:
	for box in all_grid_positions:
		box.queue_free()
	all_grid_positions.clear()

func check_placement(p: CluePanel, gb: GridBox) -> void:
	if gb == self:
		set_active_panel(p)
	elif p == current_panel:
		clear_active_panel()
