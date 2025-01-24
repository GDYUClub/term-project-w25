class_name panel
extends Area2D

@export var _panel_name: String
var _is_mouse_in: bool = false
var _is_selected: bool = false
var _grids_inside: Array[gridBox] = []

static var _can_select: bool = true

static var notifier: placed_notifier = placed_notifier.new()

func get_panel_name() -> String:
	return _panel_name

func _process(delta: float) -> void:
	#Check if the grab button is being used
	if Input.is_action_pressed("Grab"):
		#Set the panel to selected if the mouse is in the area 2D
		if _is_mouse_in and !_is_selected and _can_select:
			_is_selected = true
			_can_select = false
		#Move the panel if the object is selected
		if _is_selected:
			move_panel(get_global_mouse_position())
	#Check if the grab button is released and set set is select to false and can select to true
	elif Input.is_action_just_released("Grab") and _is_selected:
		_is_selected = false
		_can_select = true
		snap_to_grid(position)

func _on_mouse_entered() -> void:
	_is_mouse_in = true

func _on_mouse_exited() -> void:
	_is_mouse_in = false	

func move_panel(pos: Vector2) -> void:
	position.x = pos.x
	position.y = pos.y

func snap_to_grid(pos: Vector2) -> void:
	var closest_box: gridBox = find_closest_box(_grids_inside, pos)
	if closest_box != null:
		position.x = closest_box.position.x
		position.y = closest_box.position.y
		notifier.placed.emit(self,closest_box)
	else:
		notifier.placed.emit(self, null)

func _on_area_entered(area: Area2D) -> void:
	if area is gridBox:
		#Check if the area is already inside the array
		for a in _grids_inside:
			#Return if the area is already inside the array
			if a == area:
				return
		#insert grid box in array
		_grids_inside.push_back(area)

func _on_area_exited(area: Area2D) -> void:
	if area is gridBox:
		#Check if the area is inside the array
		for a in _grids_inside:
			#remove the area if it is in the array
			if a == area:
				_grids_inside.remove_at(_grids_inside.find(a,0))
		if area.current_panel == self:
			area.clear_active_panel()

func find_closest_box(boxes: Array[gridBox], pos: Vector2) -> gridBox:	
	if boxes.size() == 0:
		return null
		
	var closest_box = boxes[0]
	var closest_position = closest_box.position.distance_to(pos)
	for box in boxes:
		if box.position.distance_to(pos) < closest_position:
			closest_box = box
			closest_position = closest_box.position.distance_to(pos)
	return closest_box

class placed_notifier:
	signal placed(placed_panel, grid_container)
