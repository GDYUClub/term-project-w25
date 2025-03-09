extends Node2D

@export var app_max_cols: int = 5
@export var app_max_rows: int = 5
@export var padding: Vector2
@export var app_container: Node2D

var app_grid: Array = [] # an array to navigate desktop

var current_row: int = 0
var current_col: int = 0
var current_app: Node2D # current selected

var app_col: int = 0 # total col created
var app_row: int = 0 # total row created

# move to the top of the top to highlight 
# the window then press space to close

# there are some bugs still need to iron those out

func _ready() -> void:
	app_container.get_child(0).selected(true) # set first index to be selected
	current_app = app_container.get_child(0)

	generate_grid_array(app_max_rows, app_max_cols) # generate 2D array
	generate_fixed_layout() # generate desktop grid layout
	
func _process(_delta: float) -> void:
	if not current_app.window_active: # check if window is closed
		if Input.is_action_just_pressed("jump"):
			current_app.toggle_window(true)
			
		if Input.is_action_just_pressed("up"):
			move(0,-1)
		elif Input.is_action_just_pressed("down"):
			move(0,1)
		elif Input.is_action_just_pressed("left"):
			move(-1,0)
		elif Input.is_action_just_pressed("right"):
			move(1,0)
		
func move(col: int, row: int) -> void:
	var new_row = current_row + row
	var new_col = current_col + col
	
	# check if within bounds
	if (new_row >= 0 and new_row < app_max_rows) and (new_col >= 0 and new_col < app_max_cols):
		if app_grid[new_row][new_col]: # check if app exist
			app_grid[current_row][current_col].selected(false) # change previous selected to false

			current_row = new_row
			current_col = new_col
			
			current_app = app_grid[current_row][current_col]
			current_app.selected(true) # change current to true
	else:
		print("Invalid move: Out of bounds")

func generate_fixed_layout() -> void:
	var x_pos: float = padding.x
	var y_pos: float = padding.y

	for child in app_container.get_children():
		app_grid[app_col][app_row] = child
		child.position.x = x_pos
		child.position.y = y_pos

		app_col += 1

		if app_col == app_max_cols:
			x_pos += padding.x * 2 # move right
			y_pos = padding.y
			app_col = 0
			app_row += 1
		else:
			y_pos += padding.y * 2 # move down

func generate_grid_array(rows: int, cols: int) -> void:
	for i in range(rows):
		app_grid.append([])  # Add a new row
		for j in range(cols):
			app_grid[i].append(null)
