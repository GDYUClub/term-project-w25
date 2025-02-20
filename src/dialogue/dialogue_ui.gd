extends Control

const PATH = "res://src/dialogue/Dialogue Template.json"
enum DialogueType {LEFT, RIGHT}
var dialogue_started : bool = false

var dialogue : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	import_dialogue_data()
	print(dialogue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func import_dialogue_data() -> void: #import and convert JSON to string dictionaries
	var file = FileAccess.get_file_as_string(PATH)
	dialogue = JSON.parse_string(file) #dictionary with data
