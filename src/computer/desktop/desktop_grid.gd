extends Node

@export var row: int = 0 # number of apps per row (vertically)
# x = right y = left z = top w = bottom
@export var margin: Vector4 = Vector4(100,100,100,100)
@export var app_container: Node2D

var screen_size = DisplayServer.screen_get_size()

var app_grid: Array = [] # an array to navigate desktop

func generate_fixed_layout() -> void:
	var x_pos: float = margin.y # set x_pos to left most
	var y_pos: float = margin.z # set y_pos to top most

	# find interval pos on amount of apps per row
	var y_pos_interval: float = (screen_size.y - margin.w - margin.z) / float(row)

	var app_col: int = 0 # to track col
	var app_row: int = 0 # to track row

	for child in app_container.get_children():
		app_grid[app_col][app_row] = child # add child to array
		child.position.x = x_pos
		child.position.y = y_pos
		y_pos += y_pos_interval 
		app_col += 1

		if app_col == row: # add child to next col
			y_pos = margin.z # reset y_Pos 
			x_pos += margin.x # move to right
			app_col = 0
			app_row += 1

func generate_grid_array() -> void:
	# get amount of col
	var cols_count: float = ceil(app_container.get_child_count() / float(row))

	for i in range(row): # add row
		app_grid.append([])
		for j in (cols_count):
			app_grid[i].append(null) # add col
