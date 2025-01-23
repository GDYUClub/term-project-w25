class_name ControlRebindButtons
extends Control

@onready var label: Label = $HBoxContainer/Label as Label
@onready var keyboard_button: Button = $HBoxContainer/Keyboard as Button
@onready var controller_button: Button = $HBoxContainer/Controller as Button

#TODO: Prevent duplicate bindings

# This has to be assigned in the editor
# The name of the action has to match its name in InputMap
@export var action_name : String = ""

func _ready():
	# Initializes the action name and the buttons
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"up":
			label.text = "Up"
		"left":
			label.text = "Left"
		"down":
			label.text = "Down"
		"right":
			label.text = "Right"
		"run":
			label.text = "Run"
		"jump":
			label.text = "Jump"
		"crouch":
			label.text = "Crouch"
		"interact":
			label.text = "Interact"

func set_text_for_key() -> void:
	# Update both buttons by converting the keycodes, button index or axis
	# into a string that the user can understand
	var action_events = InputMap.action_get_events(action_name)
	
	for action_event in action_events:
		# Keyboard
		if (action_event is InputEventKey):
			var keyboard_action_keycode = OS.get_keycode_string(action_event.physical_keycode)
			keyboard_button.text = keyboard_action_keycode
		
		# Controllers have 2 types, button and motion (for joysticks)
		# Controller Button
		elif (action_event is InputEventJoypadButton):
			var controller_button_index = action_event.button_index
			var controller_action_keycode = get_controller_input_name(controller_button_index)
			controller_button.text = controller_action_keycode
		
		# Controller Joystick
		elif (action_event is InputEventJoypadMotion):
			var controller_joystick_axis = action_event.axis
			var controller_joystick_axis_value = action_event.axis_value
			var controller_action_keycode = get_controller_joystick_input(controller_joystick_axis, controller_joystick_axis_value)
			controller_button.text = controller_action_keycode

# We should use icons for controller input, I put text for now
# PLACEHOLDER TEXT
func get_controller_input_name(button_index: int) -> String:
	match button_index:
		0:
			return "A"
		1:
			return "B"
		2:
			return "X"
		3:
			return "Y"
		4:
			return "View"
		5:
			return "Xbox"
		6:
			return "Menu"
		7:
			return "LSB"
		8:
			return "RSB"
		9:
			return "LB"
		10:
			return "RB" 
		11:
			return "D-PAD Up" 
		12:
			return "D-PAD Down"
		13: 
			return "D-PAD Left"
		14:
			return "D-Pad Right"
		_:
			return "Unassigned"
	
# PLACEHOLDER TEXT
func get_controller_joystick_input(axis: int, axis_value: float) -> String:
	
	if axis == 4:
		return "LT"
	elif axis == 5:
		return "RT"
	elif axis_value < 0:
		if axis == 0:
			return "LS LEFT"
		elif axis == 1:
			return "LS UP"
		elif axis == 2:
			return "RS LEFT"
		elif axis == 3:
			return "RS UP"
	elif axis_value > 0:
		if axis == 0:
			return "LS RIGHT"
		elif axis == 1:
			return "LS DOWN"
		elif axis == 2:
			return "RS RIGHT"
		elif axis == 3:
			return "RS DOWN"
	
	return "Unassigned"

func _on_keyboard_toggled(toggled_on: bool) -> void:
	
	# If the button is click then the player can rebind this action
	if toggled_on:
		keyboard_button.text = "Press any key..."

		# Make all other buttons unselectable while rebinding
		for i in get_tree().get_nodes_in_group("rebind_button"):
			i.controller_button.toggle_mode = false
			
			if i.action_name != self.action_name:
				i.keyboard_button.toggle_mode = false

	else:
		# Renable all other buttons
		for i in get_tree().get_nodes_in_group("rebind_button"):
			i.controller_button.toggle_mode = true
			
			if i.action_name != self.action_name:
				i.keyboard_button.toggle_mode = true

		# Update to the new binding
		set_text_for_key()

func _on_controller_toggled(toggled_on: bool) -> void:
	
	# If the button is click then the player can rebind this action
	if toggled_on:
		controller_button.text = "Press any key..."

		# Make all other buttons unselectable while rebinding
		for i in get_tree().get_nodes_in_group("rebind_button"):
			i.keyboard_button.toggle_mode = false
			
			if i.action_name != self.action_name:
				i.controller_button.toggle_mode = false

	else:
		# Renable all other buttons
		for i in get_tree().get_nodes_in_group("rebind_button"):
			i.keyboard_button.toggle_mode = true
			
			if i.action_name != self.action_name:
				i.controller_button.toggle_mode = true

		# Update to the new binding
		set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	
	# Change the binding, if valid, and then reset button state
	# So that the toggle functions above get called again, which will update the text
	# and also enable the other buttons
	rebind_action_key(event)
	
	keyboard_button.button_pressed = false
	controller_button.button_pressed = false
	
func _unhandled_input(event: InputEvent) -> void:
	
	# Make sure motion is from a controller
	if (event.get_class() == "InputEventMouseMotion"):
		return
		
	# The axis value has to exceed the threshold of 0.5 in order to count
	if (event.get_class() == "InputEventJoypadMotion" and event.axis_value < 0.5 and event.axis_value > -0.5):
		return
	
	rebind_action_key(event)
	
	keyboard_button.button_pressed = false
	controller_button.button_pressed = false

func rebind_action_key(event: InputEvent) -> void:
	var action_events = InputMap.action_get_events(action_name)
	var remove_binding = false
	
	# Remove the event of the same type as the new event
	# (If keyboard event, remove the last keyboard event and
	# and controller event, remove the last controller event)
	# Also make sure the respective button for the input is pressed
	for action_event in action_events:

		if action_event.get_class() == "InputEventKey" and event.get_class() == "InputEventKey":
			if !keyboard_button.button_pressed:
				return
			
			# Remove the existing event
			InputMap.action_erase_event(action_name, action_event)
			remove_binding = true
			break

		# If the action_event is a controller input (InputEventJoypadButton or InputEventJoypadMotion)
		elif (is_controller_input(action_event.get_class()) and is_controller_input(event.get_class())):
			if !controller_button.button_pressed:
				return

			# Remove the existing event
			InputMap.action_erase_event(action_name, action_event)
			remove_binding = true
			break

	# If no binding was removed, then don't add a new one
	if (!remove_binding):
		return
	
	# Add the new event
	InputMap.action_add_event(action_name, event)

func is_controller_input(name: String) -> bool:
	
	# Inputs from the controller are of these 2 types
	if (name == "InputEventJoypadButton" or name == "InputEventJoypadMotion"):
		return true
	
	return false
