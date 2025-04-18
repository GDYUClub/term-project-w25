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

var think_bubble = preload("res://assets/sprites/ui/thought_bubble.png")
var talk_bubble = preload("res://assets/sprites/ui/talk_bubble.png")
var shout_bubble = preload("res://assets/sprites/ui/shout_bubble.png")
var wisper_bubble = preload("res://assets/sprites/ui/whipser_bubble.png")
var narrator_bubble = preload("res://assets/sprites/ui/narrator_bubble.png")

var text_rendering:bool = false
var new_dialogue_input_buffer = true

const DEFAULT_DIALOGUE :JSON= preload("res://src/dialogue/_Dialogue-Default.json")

signal dialogue_ended

signal solved_page_puzzle

enum LANGUAGE {ENGLISH, FRENCH}
@export var language : LANGUAGE = LANGUAGE.ENGLISH
@export var DIALOGUE_JSON : JSON
@export var INQUIRY_DIALOGUE_JSON : JSON
#npc ui
@onready var dialogue_ui: Control = %DialogueUI
@onready var character_1: TextureRect = %DialogueUI/Background/dialogueCharacter1
@onready var bottom_dialogue_textbox: TextureRect = %DialogueUI/Background/bottomTextBox
@onready var bottom_dialogue_text: Label = %DialogueUI/Background/bottomTextBox/Text
@onready var bottom_dialogue_name: Label = %DialogueUI/Background/bottomTextBox/Name

@onready var character_2: TextureRect = %DialogueUI/Background/dialogueCharacter2
@onready var top_dialogue_textbox: TextureRect = %DialogueUI/Background/topTextBox
@onready var top_dialogue_text: Label = %DialogueUI/Background/topTextBox/Text
@onready var top_dialogue_name: Label = %DialogueUI/Background/topTextBox/Name

#button ui
@onready var button_1: Button = %DialogueUI/Background/ButtonHolder/Button1
@onready var button_2: Button = %DialogueUI/Background/ButtonHolder/Button2
@onready var button_3: Button = %DialogueUI/Background/ButtonHolder/Button3
@onready var button_leave: Button = %DialogueUI/Background/ButtonHolder/LeaveButton

#image 
@onready var polaroidFrame := %DialogueUI/Background/PolaroidFrame
@onready var polaroidImage := %DialogueUI/Background/PolaroidFrame/PolaroidImage

#player handling
@onready var alert_sprite: Sprite2D = $"../Player/AlertSprite"
@onready var player = $"../Player"

signal dialogue_event

func _ready() -> void:
	print(polaroidFrame)
	import_dialogue_data()
	button_leave.pressed.connect(leave_dialogue)

func _process(delta: float) -> void: #for checking player skip input
	#same input is being used twice. once in 
	if(Input.is_action_just_pressed("dialogue") && (dialogue_ongoing == true)):
		#fixes a bug where the action just pressed is propigated twice, once in the player script and once here.
		if new_dialogue_input_buffer:
			new_dialogue_input_buffer = false
			return
		#await get_tree().create_timer(.1).timeout
		if text_rendering:
			text_rendering = false
			return
		if(type == DialogueType.NPC):
			adjust_npc_dialogue()


func import_dialogue_data() -> void: #import and convert JSON to string dictionaries
	dialogue = DIALOGUE_JSON.get_data()
	inquiry_dialogue = INQUIRY_DIALOGUE_JSON.get_data()

func load_npc_dialogue(new_start_id : int, new_end_id : int, speaker_1_sprite: Texture, speaker_2_sprite:Texture): #initial method to load visual novel dialogue
	new_dialogue_input_buffer = true
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

		render_speach_bubble()
		render_image()
		render_text(bottom_dialogue_text,bottom_dialogue_name)
		

		if index == start_id:
			bottom_dialogue_textbox.visible = true
			top_dialogue_textbox.visible = false
		else:
			top_dialogue_name.text = dialogue[str(index-1)]["SPEAKER_NAME"]
			top_dialogue_text.text = dialogue[str(index-1)][LANGUAGE.keys()[language]]
			top_dialogue_textbox.visible = true
		character_1.modulate = Color(1, 1, 1, 1.0 if character_index == 0 else 0.8)
		character_2.modulate = Color(1, 1, 1, 1.0 if character_index == 1 else 0.8)
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
		index += 1
	elif can_branch:
		print("waiting on player choice")
		print("DEBUG: dialogue.size: " + str(dialogue.size()) + " index: " + str(index) + " end_id: " + str(4))
	else:
		dialogue_ui.visible = false;
		dialogue_ongoing = false
		alert_sprite.visible = false
		player.can_move = true
		player.in_dialouge = false
		dialogue_ended.emit()
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
		#come up with a better solution 
		AudioManager.play_sfx(preload("res://assets/sound/sfx/incorrect.ogg"))
		dialogue = DEFAULT_DIALOGUE.get_data()
		var start : int = 0
		var end: int = 0
		load_npc_dialogue(start, end, c1Texture, c2Texture)
		dialogue = DIALOGUE_JSON.get_data()

	await dialogue_ended
	npc.inquiry_over.emit()

func execute_command(command_string : String):
	print("command called: " + command_string)
	if(command_string[0] != "/"):
		print("signal emitted: " + command_string)
		dialogue_event.emit(command_string)
	else:
		print("command!")
		var selected_command = command_string.substr(1,-1)
		var command = selected_command.split("_")[0]
		var value = selected_command.split("_")[1]
		print(selected_command,command,value)

		match command.to_lower():
			"add":
				var clue = %ClueDatabase.itemDict[int(value)]
				Inventory.add_item(clue)
			"remove":
				var clue = %ClueDatabase.itemDict[int(value)]
				Inventory.remove_item(clue)
			_:
				print("incorrect command")


func render_speach_bubble() -> void:
	var character_index : int = dialogue[str(index)]["SPEAKER_ID"]
	var bot_bubble_type:String = dialogue[str(index)]["BUBBLE_TYPE"]


	var prev_character_index : int = dialogue[str(index - 1)]["SPEAKER_ID"] if index > 0 else 0
	var top_bubble_type:String = dialogue[str(index -1)]["BUBBLE_TYPE"] if index > 0 else "TALK"
	
	match top_bubble_type:
		"TALK":
			top_dialogue_textbox.texture = talk_bubble
		"THINK":
			top_dialogue_textbox.texture = think_bubble
		"SHOUT":
			top_dialogue_textbox.texture = shout_bubble
		"WISPER":
			top_dialogue_textbox.texture = wisper_bubble
		"NARRATOR":
			top_dialogue_textbox.texture = narrator_bubble

	match bot_bubble_type:
		"TALK":
			bottom_dialogue_textbox.texture = talk_bubble
		"THINK":
			bottom_dialogue_textbox.texture = think_bubble
		"SHOUT":
			bottom_dialogue_textbox.texture = shout_bubble
		"WISPER":
			bottom_dialogue_textbox.texture = wisper_bubble
		"NARRATOR":
			bottom_dialogue_textbox.texture = narrator_bubble


	# handle flipping the diablog boxes
	if character_index == 0:
		bottom_dialogue_textbox.flip_h = false
	if character_index == 1:
		bottom_dialogue_textbox.flip_h = true

	if prev_character_index == 0:
		top_dialogue_textbox.flip_h = false
	if prev_character_index == 1:
		top_dialogue_textbox.flip_h = true

func render_image() -> void:
	var current_dialogue = dialogue[str(index)]
	if "IMAGE" in current_dialogue and current_dialogue["IMAGE"] != null:
	#if "IMAGE" in current_dialogue:
		polaroidFrame.visible = true
		polaroidImage.texture = load(dialogue[str(index)]["IMAGE"])
	else:
		polaroidFrame.visible = false

func render_text(textLabel:Label, nameLabel:Label):
	#renders text char by char
	text_rendering = true
	nameLabel.text = dialogue[str(index)]["SPEAKER_NAME"]
	var textSrc = dialogue[str(index)][LANGUAGE.keys()[language]]
	var currText := ""
	for c in textSrc:
		if text_rendering == false:
			bottom_dialogue_text.text = dialogue[str(index-1)][LANGUAGE.keys()[language]]
			break

		#AudioPlayer.play_sfx(preload("res://assets/sound/sfx/undertale/snd_txt1.mp3"))
		var delay = 0.015
		currText += c
		textLabel.text = currText
		if [",",".","!","?"].has(c): 
			delay = 0.1
		await get_tree().create_timer(delay).timeout
	text_rendering = false
