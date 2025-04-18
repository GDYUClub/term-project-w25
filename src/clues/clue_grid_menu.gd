extends Control
class_name inventory_ui
# how to set up this system
# what info would I need to pass into this object:
# the panels
# the correct panel layout
# the correct layout can be baked into the panel, have them include a correct_panel value

# this should be based on the number of clues from the player
@export var clue_count: int
@export var s_start_id: int # success start
@export var s_end_id: int #success end
@export var jane_sprite: Texture
@onready var grid_cell_scene: PackedScene = preload("res://src/clues/grid_cell.tscn")
@onready var panel_scene: PackedScene = preload("res://src/clues/clue_panel.tscn")
@onready var document_view: ColorRect = $DocumentView
@onready var document: TextureRect = $DocumentView/Document



var selected_grid : Area2D = null
var scroll_index : int = 0

var inventory_size: int = 3 # Number of rows inventory will have
var player_clues: Array[Clue] = []

var clue_grid_cells: Array[GridBox] = []
var item_grid_cells: Array[GridBox] = []
var all_grid_cells: Array[GridBox] = []

var panels: Array[CluePanel] = []

const PANEL_SIZE: int = 184
const INITIAL_POSITION: Vector2 = Vector2(400,200)
const INITIAL_ITEM_POSITION: Vector2 = Vector2(870, 600)
const OFFSET: Vector2 = Vector2(150, 150)

signal puzzle_solved
var solved: bool = false

var tween : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_ready()

func do_ready():
	# we should filter out items that aren't clues
	GridBox.all_grid_positions.clear()
	destroy_previous()
	player_clues = Inventory.get_items()
	print(player_clues)
	populate_clue_panels()
	populate_grid_cells()
	generate_total_grids()
	scroll_index = 0 + len(clue_grid_cells)
	if len(panels) > 0:
		selected_grid = all_grid_cells[0+ len(clue_grid_cells)]
		selected_grid.on_hover()
	print('done this')

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
	if Input.is_action_just_pressed("scroll_left") or Input.is_action_just_pressed("scroll_right"):
		if visible:
			AudioManager.play_sfx(preload("res://assets/sound/sfx/nav.ogg"))
		switch_panel()
	if self.visible == true:
		test_panels()
		if(Input.is_action_just_pressed("interact")):
			if selected_grid != null and selected_grid.current_clue != null and selected_grid.current_clue.clue.type == Clue.Type.DOCUMENT and document_view.visible == false:
				open_document(selected_grid.current_clue.clue)
			else:
				close_document()

func test_panels() -> void:
	if Inventory.get_item_count() > 0:
		if panels_correct():
			AudioManager.play_sfx(preload("res://assets/sound/sfx/correct.ogg"))
			solved = true
			puzzle_solved.emit()
			visible = false
			%DialogueManager.load_npc_dialogue(s_start_id, s_end_id, jane_sprite , null)
			$CorrectLabel.text = "Correct!"
		else:
			$CorrectLabel.text = "Wrong..."

func addClueGrid(index : int, c : int, r : int ):
	var gridCellInst: GridBox = grid_cell_scene.instantiate()
	gridCellInst.id = index
	gridCellInst.position.x = INITIAL_ITEM_POSITION.x + (OFFSET.x * c)
	gridCellInst.position.y = INITIAL_ITEM_POSITION.y + (OFFSET.y * r)
	gridCellInst.set_active_panel(panels[index]) 
	$GridCells.add_child(gridCellInst)
	item_grid_cells.append(gridCellInst)

func addSolutionGrid(index : int, c : int, r : int):
	var gridCellInst: GridBox = grid_cell_scene.instantiate()
	gridCellInst.id = index
	gridCellInst.position.x = INITIAL_POSITION.x + (OFFSET.x * c)
	gridCellInst.position.y = INITIAL_POSITION.y + (OFFSET.y * r)
	$GridCells.add_child(gridCellInst)
	clue_grid_cells.append(gridCellInst)
	gridCellInst.numberLabel.text = str(index)

func addPanel(clue : Clue, grid : GridBox = null) -> CluePanel:
	var panelInst = panel_scene.instantiate()
	panelInst.clue = clue
	panelInst.panel_id = clue.correct_panel
	$Panels.add_child(panelInst)
	panels.append(panelInst)
	panelInst.numberLabel.text = str(clue.id)
	if grid != null:
		grid.set_active_panel(panelInst)
		panelInst.position = grid.position
	return panelInst
func populate_clue_panels():
	for j in range(100):
		if(j < len(player_clues)):
			addPanel(player_clues[j])
		else:
			panels.append(null)
	CluePanel._can_select = true
	var rows := 3
	# it's always two for now
	var cols = 7
	var i = 0
	for r in rows:
		for c in cols:
			addClueGrid(i, c, r)
			i += 1
	i = 0
	for cell in item_grid_cells:
		if !panels.is_empty() && i < panels.size() and panels.get(i) != null:
			panels[i].position.x = cell.position.x
			panels[i].position.y = cell.position.y
			i += 1

func open_document(clue : Clue):
	document_view.visible = true
	document.texture = clue.documentSprite

func close_document():
	document_view.visible = false

func populate_grid_cells():
	var rows := clue_count
	var cols = 2
	var i = 0
	for r in rows:
		for c in cols:
			addSolutionGrid(i, c, r)
			i += 1
			if i == clue_count:
				break
		if i == clue_count:
			break


func generate_total_grids():
	all_grid_cells = clue_grid_cells + item_grid_cells  
	for i in range(len(all_grid_cells)):
		all_grid_cells[i].scroll_id = i;
func panels_correct() -> bool:
	#all items secured, then we can check if correct
	#print_debug(clue_count >= Inventory.get_item_count())
	if clue_count <= Inventory.get_item_count():
		for grid_cell in clue_grid_cells:
			if grid_cell.correct_panel == false:
				return false
		print("TRUE")
		return true
	else:
		return false

func switch_panel():
	if not visible or selected_grid == null:
		return  

	var prev_grid = selected_grid  
	close_document()
	if Input.is_action_just_pressed("scroll_left") and scroll_index - 1 >= 0:
		scroll_index -= 1  

	elif Input.is_action_just_pressed("scroll_right") and scroll_index + 1 < len(all_grid_cells):
		scroll_index += 1  

	else:
		return  

	
	selected_grid = all_grid_cells[scroll_index] if scroll_index < len(all_grid_cells) else null
	
	if prev_grid:
		prev_grid.off_hover()
	if selected_grid:
		selected_grid.on_hover()
	_update_ui(selected_grid.current_clue)

func _update_ui(panelArea):
	if panelArea == null: return
	%ClueTitle.text = panelArea.clue.name
	%ClueDesc.text = panelArea.clue.desc
	%ClueTag.text = Clue.Type.keys()[panelArea.clue.type]
	pass

func modulating_ui():
	if tween != null:
		tween.kill()
	tween = get_tree().create_tween();
	tween.tween_property($CorrectLabel, "modulate:a", 1, 1)
	tween.tween_property($CorrectLabel, "modulate:a", 0, 3)
