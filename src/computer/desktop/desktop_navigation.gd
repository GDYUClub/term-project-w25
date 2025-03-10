extends Node

@export var grid: Node
@export var exit: Node2D

var app_grid: Array
var current_index: Vector2 = Vector2(0,0)

func _ready():
	app_grid = grid.app_grid

func _process(_delta: float) -> void:
	if not app_grid[current_index.y][current_index.x].image_active: # If currently in desktop
		select_input() # detect any selecting input
		move_input() # detect any movement inputs
	else: # move in folder / image
		image_input() # handles inputs for the images shown

func move_input() -> void:
	var direction: Vector2 = Vector2.ZERO
	if not exit.exit_active: # check if not at the exit
		if Input.is_action_just_pressed("up"):
			direction.y -= 1
		elif Input.is_action_just_pressed("down"):
			direction.y += 1
		elif Input.is_action_just_pressed("left"):
			direction.x -= 1
		elif Input.is_action_just_pressed("right"):
			direction.x += 1

	if is_min_cell(current_index): # check if at bottom of desktop
		if Input.is_action_just_pressed("down"):
			app_grid[current_index.y][current_index.x].icon_selected(false)
			exit.icon_selected(true) # highlight the exit
		if Input.is_action_just_pressed("up"):
			app_grid[current_index.y][current_index.x].icon_selected(true)
			exit.icon_selected(false) # unhighlight the exit

	if direction != Vector2.ZERO:
		move_to_valid_cell(direction) # move

func move_to_valid_cell(direction: Vector2) -> void:
	var new_index = current_index + direction # add direction
	new_index.x = clamp(new_index.x, 0, app_grid[0].size() - 1)
	new_index.y = clamp(new_index.y, 0, app_grid.size() - 1)

	if is_valid_cell(new_index):
		current_index = new_index
		move_in_desktop() # move

func is_valid_cell(index: Vector2) -> bool:
	if index.y >= 0 and index.y < app_grid.size(): # check if within bounds
		if index.x >= 0 and index.x < app_grid[index.y].size():
			return app_grid[index.y][index.x] != null
	return false

func move_in_desktop() -> void:
	for i in range(app_grid.size()):
		for j in range(app_grid[i].size()):
			if app_grid[i][j] != null:
				app_grid[i][j].icon_selected(false) # unhighlight

	if app_grid[current_index.y][current_index.x]: # check if valid
		if not exit.exit_active: # check if not at the exit
			app_grid[current_index.y][current_index.x].icon_selected(true) # highlight

func image_input() -> void:
	if not app_grid[current_index.y][current_index.x].is_folder: # check if not a folder
		if Input.is_action_just_pressed("up"): # check if moved up
			app_grid[current_index.y][current_index.x].image_selected(true)
		elif Input.is_action_just_pressed("down"): # check if moved down
			app_grid[current_index.y][current_index.x].image_selected(false)

		if app_grid[current_index.y][current_index.x].exit_active: # if done any
			if Input.is_action_just_pressed("jump"): # to close image and return to desktop
				app_grid[current_index.y][current_index.x].image_selected(false)
				app_grid[current_index.y][current_index.x].toggle_image()

func select_input() -> void:
	if Input.is_action_just_pressed("jump"):
		if exit.exit_active:
			get_parent().queue_free() # or queue_free()
		# to prevent folder from closing and opening at the same time
		elif app_grid[current_index.y][current_index.x].is_folder: # check if folder
			if app_grid[current_index.y][current_index.x].exit_active:
				app_grid[current_index.y][current_index.x].image_selected(false)
				return
		app_grid[current_index.y][current_index.x].toggle_image() # toggle image view

func is_min_cell(index: Vector2) -> bool:
	if index.y == app_grid.size() - 1:
		return true
	return false
