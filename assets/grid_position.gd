class_name gridBox
extends Area2D

@export var desired_panel_name: String
var current_panel:panel
var correct_panel: bool = false
static var all_grid_positions: Array[gridBox]

#Sets the current panel to p and checks if its the right panel
func set_active_panel(p: panel) -> void:
	#Set current panel to p
	current_panel = p
	#Check if it is the correct panel
	correct_panel = is_right_panel(desired_panel_name, current_panel.get_panel_name())
	
	if gridBox.all_panels_correct():
		print("YOU ARE DONE")
		gridBox.delete_grid()

func clear_active_panel() -> void:
	current_panel = null
	correct_panel = false

func is_right_panel(panel1_name: String, panel2_name: String) -> bool:
	if panel1_name == panel2_name:
		return true
	else:
		return false

func _ready() -> void:
	all_grid_positions.push_back(self)
	panel.notifier.placed.connect(check_placement.bind())

static func all_panels_correct() -> bool:
	for box in all_grid_positions:
		if box.correct_panel == false:
			return false
	return true

static func delete_grid() -> void:
	for box in all_grid_positions:
		box.queue_free()
	all_grid_positions.clear()

func check_placement(p: panel, gb: gridBox) -> void:
	if gb == self:
		set_active_panel(p)
	elif p == current_panel:
		clear_active_panel()
