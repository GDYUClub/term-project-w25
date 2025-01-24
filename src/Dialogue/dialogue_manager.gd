extends Node

#const
const PATH = "res://src/Dialogue/Dialogue Template.json"
#vars
var index : int = 0
var dialogue = {}

var start_id : int = 0
var end_id : int = 0
var text_boxes : Array[dialogue_subject]
@export var test_text_boxes : Array[dialogue_subject]

func _ready() -> void: #testing in ready can be removed
	_import_dialogue_data()
	_load_dialogue(0,5, test_text_boxes)


func _process(delta: float) -> void: #for checking player skip input
	if(Input.is_action_just_pressed("dialogue")):
		_adjust_dialogue()
		print("clicked")


func _import_dialogue_data() -> void: #import and convert JSON to string dictionaries
	var file = FileAccess.get_file_as_string(PATH)
	dialogue = JSON.parse_string(file) #dictionary with data


func _load_dialogue(new_start_id : int, new_end_id : int, new_text_boxes : Array[dialogue_subject]): #initial method to load a dialogue between textboxes
			start_id = new_start_id
			end_id = new_end_id
			index = start_id
			text_boxes = new_text_boxes
			_adjust_dialogue() 


func _adjust_dialogue(): #switch to next line
	text_boxes[index - 1].visible = false
	if(dialogue.size() > 0 && index < end_id):
		text_boxes[index].visible = true
		text_boxes[index]._display_text(dialogue[str(index)]["FRENCH"])
		index += 1
		print("DEBUG: dialogue.size: " + str(dialogue.size()) + " index: " + str(index) + " end_id: " + str(4))
