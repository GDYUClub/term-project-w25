extends Node2D

@export var grid: Node
@export var sprite: Sprite2D
@export var app_array: Array[AppManager] = []
@export var app_container : Node2D
@export var window: Node2D

var is_folder: bool = true
var image_active: bool = false # if window is showing
var exit_active: bool = false

@onready var app = preload("res://src/computer/apps/apps.tscn") # preload app scene

func _ready() -> void:
	add_app_in_container() # add app array into app_container
	grid.generate_grid_array() # generate 2D array
	grid.generate_fixed_layout() # generate desktop grid layout
	app_container.get_child(0).icon_selected(true) # select first index

func toggle_image() -> void:
	image_active = !image_active
	window.visible = image_active # show or hide window
	window.global_position = DisplayServer.screen_get_size() / 2 # center window

func icon_selected(value: bool) -> void:
	sprite.material.set_shader_parameter("effect_enabled", value) # set highlight to sprite

func image_selected(value: bool) -> void:
	exit_active = value
	window.get_child(0).material.set_shader_parameter("effect_enabled", value) # set highlight to window

func add_app_in_container() -> void:
	for data in app_array:
		var instance = app.instantiate()
		instance.data = data
		app_container.add_child(instance)
