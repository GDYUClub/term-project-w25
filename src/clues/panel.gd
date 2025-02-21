class_name CluePanel
extends Area2D

@export var _panel_name: String
@export var clue: Clue

@onready var sprite: Sprite2D = $Sprite2D
@onready var numberLabel: Label = $NumberLabel

@onready var panel_desc_scene: PackedScene = preload("res://src/clues/clue_description.tscn")

var _is_mouse_in: bool = false
var _is_selected: bool = false
var _grids_inside: Array[GridBox] = []

var panel_exists: bool = false
var delay: float = 0.5
var time_elapsed: float = 0.0
var desc_panel
const OFFSET: Vector2 = Vector2(80, 30)

static var _can_select: bool = true


func get_panel_name() -> String:
	return _panel_name


func _ready() -> void:
	sprite.texture = clue.panel
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	mouse_entered.connect(func(): _is_mouse_in = true)
	mouse_exited.connect(func(): _is_mouse_in = false)


func _process(delta: float) -> void:
	if _is_mouse_in and !_is_selected:
		time_elapsed += delta
		if(!panel_exists and time_elapsed > delay):
			desc_panel = show_description()
			time_elapsed = 0
	if !_is_mouse_in or _is_selected:
		time_elapsed = 0
		if(panel_exists):
			hide_description(desc_panel)
	#Check if the grab button is being used
	if Input.is_action_pressed("grab"):
		#Set the panel to selected if the mouse is in the area 2D
		if _is_mouse_in and !_is_selected and _can_select:
			_is_selected = true
			_can_select = false
		#Move the panel if the object is selected
		if _is_selected:
			move_panel(get_global_mouse_position())
	#Check if the grab button is released and set set is select to false and can select to true
	elif Input.is_action_just_released("grab") and _is_selected:
		_is_selected = false
		_can_select = true
		snap_to_grid(position)


func move_panel(pos: Vector2) -> void:
	position = pos


func snap_to_grid(pos: Vector2) -> void:
	print("snap to grid")
	var closest_box: GridBox = find_closest_box(_grids_inside, pos)
	if closest_box != null:
		position.x = closest_box.position.x
		position.y = closest_box.position.y
		closest_box.set_active_panel(self)
	else:
		print("gridless")


func _on_area_entered(area: Area2D) -> void:
	if area is GridBox:
		if !_grids_inside.has(area):
			_grids_inside.push_back(area)


func _on_area_exited(area: Area2D) -> void:
	if area is GridBox:
		#Check if the area is inside the array
		if _grids_inside.has(area):
			_grids_inside.remove_at(_grids_inside.find(area, 0))
		if area.current_clue == self:
			area.clear_active_panel()


func find_closest_box(boxes: Array[GridBox], pos: Vector2) -> GridBox:
	if boxes.size() == 0:
		return null

	var closest_box = boxes[0]
	var closest_position = closest_box.position.distance_to(pos)
	for box in boxes:
		if box.position.distance_to(pos) < closest_position:
			closest_box = box
			closest_position = closest_box.position.distance_to(pos)
	return closest_box


func show_description():
	var panel_desc = panel_desc_scene.instantiate()
	add_child(panel_desc)
	
	var nameLabel = panel_desc.find_child("NameLabel")
	nameLabel.text = clue.name
	var descriptionLabel = panel_desc.find_child("DescriptionLabel")
	descriptionLabel.text = clue.desc
	
	panel_exists = true
	panel_desc.position.x = OFFSET.x
	panel_desc.position.y = OFFSET.y
	return panel_desc
	

func hide_description(description: Area2D) -> void:
	description.free()
	panel_exists = false
