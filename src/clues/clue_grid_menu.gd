extends Control

# how to set up this system
# what info would I need to pass into this object:
# the panels
# the correct panel layout
# the correct layout can be baked into the panel, have them include a correct_panel value

# this should be based on the number of clues from the player
@export var clue_count: int
@onready var grid_cell_scene: PackedScene = preload("res://src/clues/grid_cell.tscn")
@onready var panel_scene: PackedScene = preload("res://src/clues/clue_panel.tscn")

var selected_panel : Area2D = null
var selected_grid : Area2D = null
var scroll_index : int = 0

var inventory_size: int = 3 # Number of rows inventory will have
var player_clues: Array[Clue] = []

var clue_grid_cells: Array[GridBox] = []
var item_grid_cells: Array[GridBox] = []
var all_grid_cells: Array[GridBox] = []

var panels: Array[CluePanel] = []

const PANEL_SIZE: int = 184
const INITIAL_POSITION: Vector2 = Vector2(1000, 650)
const INITIAL_ITEM_POSITION: Vector2 = Vector2(150,200)
const OFFSET: Vector2 = Vector2(200, 200)

signal puzzle_solved
var solved: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_ready()

func do_ready():
	# we should filter out items that aren't clues
	destroy_previous()
	player_clues = Inventory.get_items()
	print(player_clues)
	populate_clue_panels()
	populate_grid_cells()
	generate_total_grids()
	if len(panels) > 0:
		selected_panel = panels[0]
		selected_grid = all_grid_cells[0]
		selected_grid.on_hover()

func destroy_previous():
	for cell in clue_grid_cells:
		if is_instance_valid(cell):
			cell.queue_free()
	clue_grid_cells.clear()

	for cell in item_grid_cells:
		if is_instance_valid(cell):
			cell.queue_free()
	item_grid_cells.clear()

	for panel in panels:
		if is_instance_valid(panel):
			panel.queue_free()
	panels.clear()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if panels_correct():
		solved = true
		puzzle_solved.emit()
		$CorrectLabel.text = "correct"
	else:
		$CorrectLabel.text = "wrong"
	switch_panel()


func populate_clue_panels():
	for j in range(12):
		if(j < len(player_clues)):
			var panelInst = panel_scene.instantiate()
			panelInst.clue = player_clues[j]
			panelInst.panel_id = j
			$Panels.add_child(panelInst)
			panels.append(panelInst)
			panelInst.numberLabel.text = str(player_clues[j].correct_panel)
		else:
			panels.append(null)
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
		if !panels.is_empty() && i < panels.size() and panels.get(i) != null:
			panels[i].position.x = cell.position.x
			panels[i].position.y = cell.position.y
			cell
			i += 1


func populate_grid_cells():
	var rows := int(ceil(player_clues.size()))
	# it's always two for now
	var cols = 2
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


func generate_total_grids():
	all_grid_cells = item_grid_cells + clue_grid_cells
	for i in range(len(all_grid_cells)):
		all_grid_cells[i].scroll_id = i;
func panels_correct() -> bool:
	for grid_cell in clue_grid_cells:
		if not grid_cell.correct_panel:
			return false
	return true

func switch_panel():
	if visible == true && selected_grid != null:
		if Input.is_action_just_pressed("scroll_left") and scroll_index - 1 >= 0:  
			selected_grid.off_hover()
			scroll_index -= 1  
			
			if panels.get(scroll_index) != null: 
				selected_panel = panels[scroll_index]
			else:
				selected_panel = null
			
			selected_grid = all_grid_cells[scroll_index]
			selected_grid.on_hover()

		elif Input.is_action_just_pressed("scroll_right") and scroll_index + 1 < len(all_grid_cells):
			selected_grid.off_hover()
			scroll_index += 1  
			
			if panels.get(scroll_index) != null:  
				selected_panel = panels[scroll_index]
			else:
				selected_panel = null
			selected_grid = all_grid_cells[scroll_index]
			selected_grid.on_hover()
		_update_ui(selected_panel)
func _update_ui(panelArea):
	if panelArea == null: return
	%ClueTitle.text = panelArea.clue.name
	%ClueDesc.text = panelArea.clue.desc
	pass
