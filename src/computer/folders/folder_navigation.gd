extends Node

@export var grid: Node

var app_grid: Array
var current_index: Vector2 = Vector2(0,0)

func _ready():
	app_grid = grid.app_grid

func _process(_delta: float) -> void:
	if get_parent().image_active: # folder opened
		if not app_grid[current_index.y][current_index.x].image_active: # Move in folder
			select_input() # open apps in folder and close folder
			move_input() # to navigate folder
		else:
			image_input() # to navigate the app opened in folder

func move_to_valid_cell(direction: Vector2) -> void:
	var new_index = current_index + direction
	new_index.x = clamp(new_index.x, 0, app_grid[0].size() - 1)
	new_index.y = clamp(new_index.y, 0, app_grid.size() - 1)

	if is_valid_cell(new_index):
		current_index = new_index
		move_in_desktop()

func is_valid_cell(index: Vector2) -> bool:
	if index.y >= 0 and index.y < app_grid.size():
		if index.x >= 0 and index.x < app_grid[index.y].size():
			return app_grid[index.y][index.x] != null
	return false

func is_max_cell(index: Vector2) -> bool:
	if index.y == 0:
		return true
	return false

func move_in_desktop() -> void:
	for i in range(app_grid.size()):
		for j in range(app_grid[i].size()):
			if app_grid[i][j] != null:
				app_grid[i][j].icon_selected(false)

	if app_grid[current_index.y][current_index.x]:
		if not get_parent().exit_active:
			app_grid[current_index.y][current_index.x].icon_selected(true)

func move_input() -> void:
	var direction: Vector2 = Vector2.ZERO
	if not get_parent().exit_active:
		if Input.is_action_just_pressed("up"):
			direction.y -= 1
		elif Input.is_action_just_pressed("down"):
			direction.y += 1
		elif Input.is_action_just_pressed("left"):
			direction.x -= 1
		elif Input.is_action_just_pressed("right"):
			direction.x += 1

	if is_max_cell(current_index):
		if Input.is_action_just_pressed("up"):
			app_grid[current_index.y][current_index.x].icon_selected(false)
			get_parent().image_selected(true)
		if Input.is_action_just_pressed("down"):
			app_grid[current_index.y][current_index.x].icon_selected(true)
			get_parent().image_selected(false)

	if direction != Vector2.ZERO:
		move_to_valid_cell(direction)

func select_input() -> void:
	if Input.is_action_just_pressed("jump"):
		if get_parent().exit_active:
			get_parent().toggle_image()
			current_index = Vector2.ZERO
			app_grid[current_index.y][current_index.x].icon_selected(true)
		else:
			app_grid[current_index.y][current_index.x].toggle_image()

func image_input() -> void:
	if Input.is_action_just_pressed("up"):
		app_grid[current_index.y][current_index.x].image_selected(true)
	elif Input.is_action_just_pressed("down"):
		app_grid[current_index.y][current_index.x].image_selected(false)
	if app_grid[current_index.y][current_index.x].exit_active:
		if Input.is_action_just_pressed("jump"):
			app_grid[current_index.y][current_index.x].image_selected(false)
			app_grid[current_index.y][current_index.x].toggle_image()
