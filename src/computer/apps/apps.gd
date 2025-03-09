extends Node2D

@export var sprite: Sprite2D
@export var window: Sprite2D
@export var name_tag: Label
@export var app_data: AppManager

var mid_pos: Vector2 = Vector2(DisplayServer.screen_get_size().x / 2, DisplayServer.screen_get_size().y / 2)

var window_active : bool = false # if window is showing
var window_leave: bool = false

func _ready() -> void:
	set_process(false) # automatically set process to false
	window.visible = false # hide
	
	if app_data: # check if valid
		apply_resource(app_data) # apply resource

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"): # if moved up
		window_leave = true
		window.material.set_shader_parameter("effect_enabled", true) # change shader param
	elif Input.is_action_just_pressed("down"): # if moved down
		window_leave = false
		window.material.set_shader_parameter("effect_enabled", false) # change shader param

	if window_leave == true:
		if Input.is_action_just_pressed("jump"):
			toggle_window(false) # close window

func apply_resource(data: AppManager) -> void: # apply the resource
	sprite.texture = data.icon
	window.texture = data.image
	name_tag.text = data.name
	#name_tag.position.y = data.icon.get_height() work in progress

func selected(value: bool) -> void:
	window.global_position = mid_pos
	sprite.material.set_shader_parameter("effect_enabled", value)

func toggle_window(value) -> void: # turn window on or off
	window_leave = false
	window.material.set_shader_parameter("effect_enabled", false)

	window.visible = value
	window_active = value
	set_process(value)
