extends Node

# this should be based on the number of clues from the player
@export var clue_count:int
@onready var grid_cell_scene:PackedScene = preload("res://src/clues/grid_cell.tscn")
@onready var panel_scene:PackedScene = preload("res://src/clues/clue_panel.tscn")

var player_clues = []

var grid_cells:Array[GridBox] = []
var panels:Array[CluePanel] = []

const PANEL_SIZE:int = 184
const INITIAL_POSITION:Vector2 = Vector2(100,100)


# static func all_panels_correct() -> bool:
# 	for box in all_grid_positions:
# 		if box.correct_panel == false:
# 			return false
# 	return true
#
# static func delete_grid() -> void:
# 	for box in all_grid_positions:
# 		box.queue_free()
# 	all_grid_positions.clear()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _make_grid() -> void:
	var i = 0
	for c in range(clue_count):



		pass




		


