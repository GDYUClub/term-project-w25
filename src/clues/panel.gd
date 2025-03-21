class_name CluePanel
extends Area2D

@export var _panel_name: String
@export var clue: Clue

@onready var sprite: TextureRect = $Clue
@onready var numberLabel: Label = $NumberLabel
@onready var panel_desc_scene: PackedScene = preload("res://src/clues/clue_description.tscn")
@onready var inventory_panel = get_node("/root/Main/InventoryUI")

var selected_box: GridBox 
var panel_id: int

var base_scale : Vector2
var extended_scale : Vector2

#controls for keyboard
const key_selection_time : float = 0.1
var _selection_with_keyboard: bool = false
var keyboard_time_elapsed: float = 0.0
var _selection_with_mouse: bool = false

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
	base_scale = scale
	extended_scale = scale * 1.2
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	mouse_entered.connect(func(): _is_mouse_in = true)
	mouse_exited.connect(func(): _is_mouse_in = false)


func _process(delta: float) -> void:
	set_keyboard_time(delta)
	description_process(delta)
	if(_is_selected):
		if(_selection_with_mouse):
			move_panel(get_global_mouse_position())
		if(_selection_with_keyboard):
			move_panel(inventory_panel.selected_grid.position)
	attempt_pickup_or_drop()

func description_process(delta) -> void:
	if _is_mouse_in and !_is_selected:
		time_elapsed += delta
		if(!panel_exists and time_elapsed > delay):
			desc_panel = show_description()
			time_elapsed = 0
	if !_is_mouse_in or _is_selected:
		time_elapsed = 0
		if(panel_exists):
			hide_description(desc_panel)

func attempt_pickup_or_drop() -> void:
	if !_selection_with_keyboard:
		if Input.is_action_pressed("grab"):
			if _is_mouse_in and !_is_selected and _can_select:
				select()
				_selection_with_mouse = true
		elif Input.is_action_just_released("grab") and _is_selected:
			deselect()
			_selection_with_mouse = false
	if !_selection_with_mouse:
		if Input.is_action_pressed("pickup_panel") and !_is_selected and keyboard_time_elapsed <= 0:
			print("BLAH:S", inventory_panel.selected_panel == self)
			if inventory_panel.selected_panel == self and _can_select:
				select()
				_selection_with_keyboard = true
				keyboard_time_elapsed = key_selection_time
		elif Input.is_action_pressed("pickup_panel") and _is_selected and keyboard_time_elapsed <= 0:
			deselect()
			_selection_with_keyboard = false
			keyboard_time_elapsed = key_selection_time

func select() -> void:
	#Set the panel to selected if the mouse is in the area 2D
	_is_selected = true
	_can_select = false
	scale = extended_scale

func deselect() -> void:
	_is_selected = false
	_can_select = true
	snap_to_grid(position)
	scale = base_scale

func move_panel(pos: Vector2) -> void:
	position = pos


func snap_to_grid(pos: Vector2) -> void:
	print("snap to grid")
	selected_box = find_closest_box(_grids_inside, pos)
	if selected_box != null:
		inventory_panel.panels[panel_id] = null;
		panel_id = selected_box.scroll_id
		inventory_panel.panels[panel_id] = self;
		position.x = selected_box.position.x
		position.y = selected_box.position.y
		selected_box.set_active_panel(self)
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

func set_keyboard_time(delta) -> void:
	if keyboard_time_elapsed > 0:
		keyboard_time_elapsed -= delta
	
