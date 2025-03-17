extends Node2D

@export var sprite: Sprite2D
@export var window: Sprite2D
@export var name_tag: Label
@export var data: AppManager

var is_folder: bool = false # if is a folder type
var image_active: bool = false # if window is showing
var exit_active: bool = false # if user wants to exit the image window

func _ready() -> void:
	apply_resource(data) # apply resource

func apply_resource(data: AppManager) -> void: # apply the resource
	sprite.texture = data.icon # add sprite image
	window.texture = data.image # add window image
	name_tag.text = data.name # add name
	
func icon_selected(value: bool) -> void:
	sprite.material.set_shader_parameter("effect_enabled", value) # set highlight to sprite

func image_selected(value: bool) -> void:
	exit_active = value
	window.material.set_shader_parameter("effect_enabled", value) # set highlight to window

func toggle_image() -> void:
	image_active = !image_active

	window.visible = image_active # show or hide window
	window.global_position = DisplayServer.screen_get_size() / 2
