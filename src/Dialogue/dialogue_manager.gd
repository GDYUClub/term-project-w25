class_name DialogueManager
extends Node
#const
const PATH = "res://src/Dialogue/Dialogue Template.json"
#vars
var index : int = 0
var dialogue : Dictionary = {}

var start_id : int = 0
var end_id : int = 0
var text_boxes : Array[TextBox]

var dialogue_ongoing : bool = false
func _ready() -> void:
	import_dialogue_data()

func _process(delta: float) -> void: #for checking player skip input
	if(Input.is_action_just_pressed("dialogue") && (dialogue_ongoing == true)):
		adjust_dialogue()
		print("clicked")


func import_dialogue_data() -> void: #import and convert JSON to string dictionaries
	var file = FileAccess.get_file_as_string(PATH)
	dialogue = JSON.parse_string(file) #dictionary with data


func load_dialogue(new_start_id : int, new_end_id : int, new_text_boxes : Array[TextBox]): #initial method to load a dialogue between textboxes
			dialogue_ongoing = true
			start_id = new_start_id
			end_id = new_end_id
			index = start_id
			text_boxes = new_text_boxes
			print("dialogue loaded")
			adjust_dialogue()


func adjust_dialogue(): #switch to next line
	text_boxes[index - 1].reset_box()
	if(dialogue.size() > 0 && index < end_id):
		text_boxes[index].visible = true
		text_boxes[index].display_text(dialogue[str(index)]["ENGLISH"])
		index += 1
		print("DEBUG: dialogue.size: " + str(dialogue.size()) + " index: " + str(index) + " end_id: " + str(4))
		print("text loaded")
	else:
		dialogue_ongoing = false
