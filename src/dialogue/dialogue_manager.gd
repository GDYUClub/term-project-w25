class_name DialogueManager
extends Node
#const
const PATH = "res://src/dialogue/Dialogue Template.json"
#vars
var index : int = 0
var dialogue : Dictionary = {}
enum DialogueType {NPC, INTERACTABLE}
var type : DialogueType

var start_id : int = 0
var end_id : int = 0
var text_boxes : Array[TextBox]

var dialogue_ongoing : bool = false

#npc ui
@onready var dialogue_ui: Control = %DialogueUI
@onready var character_1: TextureRect = %DialogueUI/Background/dialogueCharacter1
@onready var character_1_textbox: ColorRect = %DialogueUI/Background/dialogueCharacter1/Textbox
@onready var character_1_text: Label = %DialogueUI/Background/dialogueCharacter1/Textbox/Text
@onready var character_1_name: Label = %DialogueUI/Background/dialogueCharacter1/Textbox/Name

@onready var character_2: TextureRect = %DialogueUI/Background/dialogueCharacter2
@onready var character_2_textbox: ColorRect = %DialogueUI/Background/dialogueCharacter2/Textbox
@onready var character_2_text: Label = %DialogueUI/Background/dialogueCharacter2/Textbox/Text
@onready var character_2_name: Label = %DialogueUI/Background/dialogueCharacter2/Textbox/Name

#player handling
@onready var alert_sprite: Sprite2D = $"../Player/AlertSprite"



func _ready() -> void:
	import_dialogue_data()

func _process(delta: float) -> void: #for checking player skip input
	if(Input.is_action_just_pressed("dialogue") && (dialogue_ongoing == true)):
		if(type == DialogueType.NPC):
			adjust_npc_dialogue()
		elif(type == DialogueType.INTERACTABLE):
			adjust_interactable_dialogue()
		print("clicked")


func import_dialogue_data() -> void: #import and convert JSON to string dictionaries
	var file = FileAccess.get_file_as_string(PATH)
	dialogue = JSON.parse_string(file) #dictionary with data


func load_interactable_dialogue(new_start_id : int, new_end_id : int, new_text_boxes : Array[TextBox]): #initial method to load a dialogue between textboxes
			dialogue_ongoing = true
			start_id = new_start_id
			end_id = new_end_id
			index = start_id
			text_boxes = new_text_boxes
			type = DialogueType.INTERACTABLE
			print("pre-requisites loaded, type: interactable")
			adjust_interactable_dialogue()


func load_npc_dialogue(new_start_id : int, new_end_id : int, speaker_1_sprite: Texture, speaker_2_sprite:Texture): #initial method to load visual novel dialogue
	prints(new_start_id,new_end_id,speaker_1_sprite,speaker_2_sprite)
	dialogue_ongoing = true
	start_id = new_start_id
	end_id = new_end_id
	index = start_id
	type = DialogueType.NPC
	character_1.texture = speaker_1_sprite
	character_2.texture = speaker_2_sprite
	dialogue_ui.visible = true
	print("pre-requisites loaded, type: npc")
	adjust_npc_dialogue()

func adjust_npc_dialogue(): #switch to next line
	if(dialogue.size() > 0 && index < end_id):
		var character_index : int = dialogue[str(index)]["SPEAKER_ID"]
		if character_index == 0: #if speaker is the first character
			character_1_name.text = dialogue[str(index)]["SPEAKER_NAME"]
			character_1_text.text = dialogue[str(index)]["FRENCH"]
			character_1_textbox.visible = true
			character_2_textbox.visible = false
		else:
			character_2_name.text = dialogue[str(index)]["SPEAKER_NAME"]
			character_2_text.text = dialogue[str(index)]["FRENCH"]
			character_1_textbox.visible = false
			character_2_textbox.visible = true
		character_1.modulate = Color(1, 1, 1, 1.0 if character_index == 0 else 0.4)
		character_2.modulate = Color(1, 1, 1, 1.0 if character_index == 1 else 0.4)
		index += 1
		print("DEBUG: dialogue.size: " + str(dialogue.size()) + " index: " + str(index) + " end_id: " + str(4))
		print("text loaded")
	else:
		print("Debug")
		dialogue_ui.visible = false;
		dialogue_ongoing = false
		alert_sprite.visible = false

func adjust_interactable_dialogue(): #switch to next line
	text_boxes[index - 1].reset_box()
	if(dialogue.size() > 0 && index < end_id):
		text_boxes[index].visible = true
		text_boxes[index].display_text(dialogue[str(index)]["ENGLISH"])
		index += 1
		print("DEBUG: dialogue.size: " + str(dialogue.size()) + " index: " + str(index) + " end_id: " + str(4))
		print("text loaded")
	else:
		print("dialogue over")
		dialogue_ongoing = false
