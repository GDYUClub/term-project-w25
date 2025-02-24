extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var dialogue_manager: DialogueManager = %DialogueManager

@export var clue_button_scene : PackedScene = preload("res://src/dialogue/clue_button.tscn")
var current_npc : Area2D


func start_inquire(npc): #This method recieves a signal from the player when they inquire to an npc
	visible = true
	current_npc = npc
	
	for clue in Inventory.get_items():
		create_button(clue)

func create_button(clue: Clue):
	var button : Button = clue_button_scene.instantiate()
	button.icon = clue.icon
	button.pressed.connect(button_selected.bind(clue.id))
	grid_container.add_child(button)
	
func button_selected(id : int):
	if id != current_npc.inquiry_clue:
		close()
	else:
		succeed()

func close():
	for node in grid_container.get_children():
		grid_container.remove_child(node)
		node.queue_free()
	visible = false
	
func succeed():
	close()
	print("sending inquire dialogue to the manager...")
	#THE DIALOGUE DOES NOT CURRENTLY WORK WITH DIRRERENT DIALOGUES
	#THIS FUNCTION SHOULD SEND npc.inquiry_dialogue TO THE MANAGER
	
	#-SUDOCODE %DialogueManager.open_dialogue(npc.inquiry_dialogue)
	
