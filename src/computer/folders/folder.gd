extends Node2D

@export var sprite: Sprite2D
@export var app_array: Array[AppManager] = []
@export var app_container : Node2D
@export var window: Node2D

@export var app_max_cols : int = 5
@export var app_max_rows : int = 5
@export var padding : Vector2

var mid_pos: Vector2 = Vector2(DisplayServer.screen_get_size().x / 2, DisplayServer.screen_get_size().y / 2)

var app_grid: Array = [] # an array to navigate folder

var current_row: int = 0
var current_col: int = 0
var current_app: Node2D = null

var app_col: int = 0
var app_row: int = 0

var window_active : bool = false
var window_leave: bool = false

@onready var app = preload("res://src/computer/apps/apps.tscn") # preload app scene

func _ready() -> void:
	set_process(false) # set its own process to false to prevent unnescsary checking 
	window.visible = false # hide window
	
	generate_grid_array(app_max_rows, app_max_cols) # generate 2D array
	add_app_in_container() # add the apps from resource to the folder
	generate_fixed_layout() # generate layout in folder
	
	if app_container.get_child(0): # set first index child to selected
		app_container.get_child(0).selected(true)
		current_app = app_container.get_child(0)

func _process(_delta: float) -> void:
	if window_leave == true: # if on leave
		if Input.is_action_just_pressed("jump"):
			toggle_window(false)

	if window.visible and not current_app.window_active:
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

func toggle_window(value) -> void:
	window_leave = false
	window.get_child(0).material.set_shader_parameter("effect_enabled", false)
	
	window.visible = value
	window_active = value
	set_process(value)

func selected(value: bool) -> void:
	window.global_position = mid_pos
	sprite.material.set_shader_parameter("effect_enabled", value) # show outline shader

func move(col: int, row: int) -> void:
	var new_row = current_row + row
	var new_col = current_col + col
		
	if (new_row >= 0 and new_row < app_max_rows) and (new_col >= 0 and new_col < app_max_cols):
		window.get_child(0).material.set_shader_parameter("effect_enabled", false)
		if app_grid[new_row][new_col]:
			app_grid[current_row][current_col].selected(false)

			current_row = new_row
			current_col = new_col

			app_grid[current_row][current_col].selected(true)
			current_app = app_grid[current_row][current_col]
	else:
		if new_row < 0:
			window_leave = true
			window.get_child(0).material.set_shader_parameter("effect_enabled", true)
			current_app.selected(false)

func add_app_in_container() -> void:
	for app_data in app_array:
		var instance = app.instantiate()
		instance.app_data = app_data
		app_container.add_child(instance)

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
