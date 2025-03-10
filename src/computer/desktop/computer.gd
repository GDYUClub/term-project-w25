extends Node2D

@export var grid: Node
@export var app_container: Node2D

# How to use
# WASD to navigate the desktop
# SPACE to select the app
# In Folder go to the top app and press W to highlight Folder press SPACE to close
# In Image press W to highlight Image press SPACE to close
# To EXIT go to the bottom app in the desktop press S to highlight EXIT press SPACE to close

func _ready() -> void:
	grid.generate_grid_array() # generate 2D array
	grid.generate_fixed_layout() # generate desktop grid layout

	app_container.get_child(0).icon_selected(true) # select top left app
