extends Node2D

# how to set up this system
# what info would I need to pass into this object:
# the panels
# the correct panel layout
# the correct layout can be baked into the panel, have them include a correct_panel value

# this should be based on the number of clues from the player
@export var clue_count: int
@onready var grid_cell_scene: PackedScene = preload("res://src/clues/grid_cell.tscn")
@onready var panel_scene: PackedScene = preload("res://src/clues/clue_panel.tscn")

var inventory_size: int = 3 # Number of rows inventory will have
var player_clues: Array[Clue] = []

var clue_grid_cells: Array[GridBox] = []
var item_grid_cells: Array[GridBox] = []
var panels: Array[CluePanel] = []

const PANEL_SIZE: int = 184
const INITIAL_POSITION: Vector2 = Vector2(1000, 667)
const INITIAL_ITEM_POSITION: Vector2 = Vector2(150,200)
const OFFSET: Vector2 = Vector2(180, 180)

signal puzzle_solved
var solved: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# we should filter out items that aren't clues
	player_clues = Inventory.get_items()
	print(player_clues)
	populate_clue_panels()
	populate_grid_cells()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if panels_correct():
		solved = true
		puzzle_solved.emit()
		$CorrectLabel.text = "correct"
	else:
		$CorrectLabel.text = "wrong"


func populate_clue_panels():
	
	for clue in player_clues:
		var panelInst = panel_scene.instantiate()
		panelInst.clue = clue
		$Panels.add_child(panelInst)
		panels.append(panelInst)
		panelInst.numberLabel.text = str(clue.correct_panel)
		
	var rows := inventory_size
	# it's always two for now
	var cols = 2
	var i = 0
	for r in rows:
		for c in cols:
			var gridCellInst: GridBox = grid_cell_scene.instantiate()
			gridCellInst.id = i
			gridCellInst.position.x = INITIAL_ITEM_POSITION.x + (OFFSET.x * c)
			gridCellInst.position.y = INITIAL_ITEM_POSITION.y + (OFFSET.y * r)
			$GridCells.add_child(gridCellInst)
			item_grid_cells.append(gridCellInst)
			i += 1
	i = 0
	for cell in item_grid_cells:
		if !panels.is_empty() && i < panels.size():
			panels[i].position.x = cell.position.x
			panels[i].position.y = cell.position.y
			i += 1


func populate_grid_cells():
	var rows := int(ceil(player_clues.size()))
	# it's always two for now
	var cols = 4
	var i = 0
	for r in rows:
		for c in cols:
			var gridCellInst: GridBox = grid_cell_scene.instantiate()
			gridCellInst.id = i
			gridCellInst.position.x = INITIAL_POSITION.x + (OFFSET.x * c)
			gridCellInst.position.y = INITIAL_POSITION.y + (OFFSET.y * r)
			$GridCells.add_child(gridCellInst)
			clue_grid_cells.append(gridCellInst)
			gridCellInst.numberLabel.text = str(i)
			i += 1
			if i == player_clues.size():
				break
		if i == player_clues.size():
			break



func panels_correct() -> bool:
	for grid_cell in clue_grid_cells:
		if not grid_cell.correct_panel:
			return false
	return true
