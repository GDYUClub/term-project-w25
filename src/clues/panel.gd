class_name CluePanel
extends Area2D

@export var _panel_name: String
@export var clue: Clue
@onready var sprite: TextureRect = $Clue
@onready var numberLabel: Label = $NumberLabel
@onready var panel_desc_scene: PackedScene = preload("res://src/clues/clue_description.tscn")
@onready var inventory_panel : inventory_ui = get_node("/root/Main/UI/InventoryUI")

var selected_box: GridBox 
var panel_id: int

var base_scale : Vector2
var extended_scale : Vector2

#controls for keyboard
const key_selection_time : float = 0.5
var _selection_with_keyboard: bool = false
var keyboard_time_elapsed: float = 0.0
var _selection_with_mouse: bool = false

var _is_mouse_in: bool = false
var _is_selected: bool = false
var _grids_inside: Array[GridBox] = []

var panel_exists: bool = false
var delay: float = 0.1
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
		if(_selection_with_keyboard && _is_selected):
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
			if inventory_panel.selected_grid.current_clue == self and _can_select:
				select()
				_selection_with_keyboard = true
				keyboard_time_elapsed = key_selection_time
		elif Input.is_action_pressed("pickup_panel") and _is_selected and keyboard_time_elapsed <= 0:
			deselect()
			_selection_with_keyboard = false
			keyboard_time_elapsed = key_selection_time

func select() -> void:
	#Set the panel to selected if the mouse is in the area 2D
	print("Selected")
	_is_selected = true
	_can_select = false
	scale = extended_scale
	selected_box = find_closest_box(_grids_inside, position)

func deselect() -> void:
	snap_to_grid(position)
	scale = base_scale

func move_panel(pos: Vector2) -> void:
	position = pos


func snap_to_grid(pos: Vector2) -> void:
	var previous_box : GridBox = selected_box
	selected_box = find_closest_box(_grids_inside, pos)
	if selected_box.current_clue == null:
		previous_box.clear_active_panel()
		snap(selected_box)
	else:
		if (previous_box.current_clue.clue.type == clue.Type.MERGING and selected_box.current_clue.clue.type == clue.Type.MERGING) and previous_box != selected_box :
			merge(previous_box, selected_box)
		else:
			swap(previous_box, selected_box)

func snap(selected : GridBox):
	inventory_panel.panels[panel_id] = null
	panel_id = selected.scroll_id
	inventory_panel.panels[panel_id] = self
	position.x = selected.position.x
	position.y = selected.position.y
	selected.set_active_panel(self)
	print("snapped")
	_is_selected = false
	_can_select = true

func swap(box_a: GridBox, box_b: GridBox):
	if box_a == null:
		print("previous is null")
		return
	elif box_b == null:
		print("selected is null")
		return
	
	var panel_a = box_a.current_clue
	var panel_b = box_b.current_clue
	
	if panel_a == null or panel_b == null:
		return 
	inventory_panel.panels[box_a.scroll_id] = panel_b
	inventory_panel.panels[box_b.scroll_id] = panel_a
	
	box_a.current_clue = panel_b
	box_b.current_clue = panel_a
	
	var temp_id = box_a.scroll_id
	box_a.scroll_id = box_b.scroll_id
	box_b.scroll_id = temp_id
	
	var temp_id2 = panel_a.panel_id
	panel_a.panel_id = panel_b.panel_id
	panel_b.panel_id = temp_id2
	
	panel_a.position = box_b.position
	panel_b.position = box_a.position
	
	box_a.set_active_panel(panel_b)
	box_b.set_active_panel(panel_a)
	panel_a._is_selected = false
	panel_b._is_selected = false
	panel_a._can_select = true
	panel_b._can_select = true
	print("swapped")

func merge(box_a: GridBox, box_b: GridBox):
	#NIGHTMARE NIGHTMARE NIGHTMARE Ahh code
	#I'm so sorry this has to be seen
	#Throw everything and the kitchen sink ahh code
	if box_a.current_clue.clue.mergeResultant == box_b.current_clue.clue.mergeResultant:
		var panel_a = box_a.current_clue
		var panel_b = box_b.current_clue
		# Remove merged panels
		Inventory.remove_item(panel_a.clue)
		Inventory.remove_item(panel_b.clue)
		# Add merged result panel
		var merge_clue = box_b.current_clue.clue.mergeResultant
		var panel_c = inventory_panel.addPanel(merge_clue, box_b)
		
		box_a.clear_active_panel()
		box_b.clear_active_panel()
		box_b.set_active_panel(panel_c)
		panel_a._is_selected = false
		panel_b._is_selected = false
		panel_c._is_selected = false
		# Register the new panel
		Inventory.add_item(merge_clue)
		print(Inventory.get_items())
		# Free old panels
		await get_tree().create_timer(0.2).timeout
		_can_select = true
		print("timeout done: can select-> ", _can_select)

		panel_a.queue_free()
		panel_b.queue_free()
		
func _on_area_entered(area: Area2D) -> void:
	if area is GridBox:
		if !_grids_inside.has(area):
			_grids_inside.push_back(area)


func _on_area_exited(area: Area2D) -> void:
	if area is GridBox:
		#Check if the area is inside the array
		if _grids_inside.has(area):
			_grids_inside.remove_at(_grids_inside.find(area, 0))


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
	
