class_name DialogueManager
extends Node
#vars
var index : int = 0
var dialogue : Dictionary = {}
var inquiry_dialogue : Dictionary = {}
enum DialogueType {NPC, INTERACTABLE}
var type : DialogueType

var start_id : int = 0
var end_id : int = 0
var character_1_texture : Texture
var character_2_texture : Texture
var dialogue_ongoing : bool = false
var can_branch = false
enum LANGUAGE {ENGLISH, FRENCH}
@export var language : LANGUAGE = LANGUAGE.ENGLISH
@export var DIALOGUE_JSON : JSON
@export var INQUIRY_DIALOGUE_JSON : JSON
#npc ui
@onready var dialogue_ui: Control = %DialogueUI
@onready var character_1: TextureRect = %DialogueUI/Background/dialogueCharacter1
@onready var bottom_dialogue_textbox: ColorRect = %DialogueUI/Background/bottomTextBox
@onready var bottom_dialogue_text: Label = %DialogueUI/Background/bottomTextBox/Text
@onready var bottom_dialogue_name: Label = %DialogueUI/Background/bottomTextBox/Name

@onready var character_2: TextureRect = %DialogueUI/Background/dialogueCharacter2
@onready var top_dialogue_textbox: ColorRect = %DialogueUI/Background/topTextBox
@onready var top_dialogue_text: Label = %DialogueUI/Background/topTextBox/Text
@onready var top_dialogue_name: Label = %DialogueUI/Background/topTextBox/Name

#button ui
@onready var button_1: Button = %DialogueUI/Background/ButtonHolder/Button1
@onready var button_2: Button = %DialogueUI/Background/ButtonHolder/Button2
@onready var button_3: Button = %DialogueUI/Background/ButtonHolder/Button3
@onready var button_leave: Button = %DialogueUI/Background/ButtonHolder/LeaveButton

#player handling
@onready var alert_sprite: Sprite2D = $"../Player/AlertSprite"

signal dialogue_event

func _ready() -> void:
	import_dialogue_data()
	button_leave.pressed.connect(leave_dialogue)

func _process(delta: float) -> void: #for checking player skip input
	if(Input.is_action_just_pressed("dialogue") && (dialogue_ongoing == true)):
		if(type == DialogueType.NPC):
			adjust_npc_dialogue()


func import_dialogue_data() -> void: #import and convert JSON to string dictionaries
	dialogue = DIALOGUE_JSON.get_data()
	inquiry_dialogue = INQUIRY_DIALOGUE_JSON.get_data()

func load_npc_dialogue(new_start_id : int, new_end_id : int, speaker_1_sprite: Texture, speaker_2_sprite:Texture): #initial method to load visual novel dialogue
	top_dialogue_textbox.visible = false
	dialogue_ongoing = false
	prints(new_start_id,new_end_id,speaker_1_sprite,speaker_2_sprite)
	can_branch = false
	button_1.visible = false
	button_2.visible = false
	button_3.visible = false
	button_leave.visible = false
	dialogue_ongoing = true
	start_id = new_start_id
	end_id = new_end_id
	index = start_id
	type = DialogueType.NPC
	character_1_texture = speaker_1_sprite
	character_2_texture = speaker_2_sprite
	character_1.texture = speaker_1_sprite
	character_2.texture = speaker_2_sprite
	dialogue_ui.visible = true
	print("pre-requisites loaded, type: npc")
	adjust_npc_dialogue()
	dialogue_ongoing = true

func adjust_npc_dialogue(): #switch to next line
	if(dialogue.size() > 0 && index <= end_id):
		#handling the name dialogue logic
		var character_index : int = dialogue[str(index)]["SPEAKER_ID"]
		if index == start_id:
			bottom_dialogue_name.text = dialogue[str(index)]["SPEAKER_NAME"]
			bottom_dialogue_text.text = dialogue[str(index)][LANGUAGE.keys()[language]]
			bottom_dialogue_textbox.visible = true
			top_dialogue_textbox.visible = false
		else:
			top_dialogue_name.text = bottom_dialogue_name.text
			top_dialogue_text.text = bottom_dialogue_text.text
			bottom_dialogue_name.text = dialogue[str(index)]["SPEAKER_NAME"]
			bottom_dialogue_text.text = dialogue[str(index)][LANGUAGE.keys()[language]]
			top_dialogue_textbox.visible = true
			print("top!")
		character_1.modulate = Color(1, 1, 1, 1.0 if character_index == 0 else 0.4)
		character_2.modulate = Color(1, 1, 1, 1.0 if character_index == 1 else 0.4)
		#handling the branching logic
		if(dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_1"] != null):
			button_1.text = dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_1"]
			var start : int = int(dialogue[str(index)]["LINK_1_ID"].split(":")[0])
			var end : int = int(dialogue[str(index)]["LINK_1_ID"].split(":")[1])
			var branch_dialogue : String = dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_1"]
			button_1.pressed.connect(func(): branch(start,end, branch_dialogue))
			button_1.visible = true
			can_branch = true
		if(dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_2"] != null):
			button_2.text = dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_2"]
			var start : int = int(dialogue[str(index)]["LINK_2_ID"].split(":")[0])
			var end : int = int(dialogue[str(index)]["LINK_2_ID"].split(":")[1])
			var branch_dialogue : String = dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_2"]
			button_2.pressed.connect(func(): branch(start,end, branch_dialogue))
			button_2.visible = true
			can_branch = true
		if(dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_3"] != null):
			button_3.text = dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_3"]
			var start : int = int(dialogue[str(index)]["LINK_3_ID"].split(":")[0])
			var end : int = int(dialogue[str(index)]["LINK_3_ID"].split(":")[1])
			var branch_dialogue : String = dialogue[str(index)][LANGUAGE.keys()[language] +"_DIALOGUE_CHOICE_3"]
			button_3.pressed.connect(func(): branch(start,end, branch_dialogue))
			button_3.visible = true
			can_branch = true
		if can_branch == true:
			button_leave.visible = true
			##
		if dialogue[str(index)]["COMMANDS"] != null:
				print("commands exist")
				var commands : Array = dialogue[str(index)]["COMMANDS"].split(":")
				for command in commands:
					execute_command(command)
		else:
			print("commands dont exist")
		index += 1
	elif can_branch:
		print("waiting on player choice")
		print("DEBUG: dialogue.size: " + str(dialogue.size()) + " index: " + str(index) + " end_id: " + str(4))
	else:
		dialogue_ui.visible = false;
		dialogue_ongoing = false
		alert_sprite.visible = false
func branch(new_start_index, new_end_index, dialogue): #branch to another dialogue
	button_1.visible = false
	button_2.visible = false
	button_3.visible = false
	button_leave.visible = false
	can_branch = false
	load_npc_dialogue(new_start_index, new_end_index, character_1_texture, character_2_texture)
	top_dialogue_text.text = dialogue
	top_dialogue_name.text = "Jane"

func leave_dialogue():
	dialogue_ui.visible = false

func start_inquiry_dialogue(npc : Area2D , item_id : int):
	var npc_name : String = npc.npc_name
	var c1Texture : Texture = npc.character1_sprite
	var c2Texture : Texture = npc.character2_sprite
	if (inquiry_dialogue.has(str(item_id)) and inquiry_dialogue[str(item_id)].has(npc_name[0].to_upper() + npc_name.substr(1, -1)) and inquiry_dialogue[str(item_id)][npc_name[0].to_upper() + npc_name.substr(1,-1)] != null):
		var inquiry : String = inquiry_dialogue[str(item_id)][npc_name[0].to_upper() + npc_name.substr(1,-1)]
		var start : int = int(inquiry.split(":")[0])
		var end: int = int(inquiry.split(":")[1])
		load_npc_dialogue(start, end, c1Texture, c2Texture)
	else:
		var start : int = 0
		var end: int = 0
		load_npc_dialogue(start, end, c1Texture, c2Texture)

func execute_command(command_string : String):
	print("command called")
	if(command_string[0] != "/"):
		dialogue_event.emit(command_string)
		print("event!")
	else:
		print("command!")
		var selected_command = command_string.substr(1,-1)
		var command = selected_command.split("_")[0]
		var value = selected_command.split("_")[1]
		match command.to_lower():
			"add":
				Inventory.add_item(%ClueDatabase.itemDict[int(value)])
			"remove":
				Inventory.remove_item(%ClueDatabase.itemDict[int(value)])
			_:
				print("incorrect command")
