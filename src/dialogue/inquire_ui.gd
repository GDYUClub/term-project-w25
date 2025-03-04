extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var dialogue_manager: DialogueManager = %DialogueManager
@onready var player: CharacterBody2D = %Player

@export var clue_button_scene : PackedScene = preload("res://src/dialogue/clue_button.tscn")
var current_npc : Area2D

func _ready() -> void:
	player.start_inquire.connect(start_inquire)
	player.end_inquire.connect(close)

func start_inquire(npc): #This method recieves a signal from the player when they inquire to an npc
	clear()
	visible = true
	current_npc = npc
	print_debug("Inquired");
	for clue in Inventory.get_items():
		create_button(clue)

func create_button(clue: Clue):
	var button : Button = clue_button_scene.instantiate()
	button.icon = clue.icon
	button.pressed.connect(button_selected.bind(clue.id))
	grid_container.add_child(button)
	
func button_selected(id : int):
		succeed(id)

func close():
	clear()
	visible = false
	
func clear():
	for node in grid_container.get_children():
		grid_container.remove_child(node)
		node.queue_free()
func succeed(id : int):
	close()
	dialogue_manager.start_inquiry_dialogue(current_npc, id)
	
	
