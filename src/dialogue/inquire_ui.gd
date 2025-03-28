extends Control

@onready var hbox_container: HBoxContainer = $HBoxContainer
@onready var dialogue_manager: DialogueManager = %DialogueManager
@onready var player: CharacterBody2D = %Player

@export var clue_button_scene : PackedScene = preload("res://src/dialogue/clue_button.tscn")
var current_npc : Area2D
var can_reopen = true

func _ready() -> void:
	player.start_inquire.connect(start_inquire)
	player.end_inquire.connect(close)

func start_inquire(npc): #This method recieves a signal from the player when they inquire to an npc
	if !can_reopen: # to prevent double just_pressed input issues
		return
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
	hbox_container.add_child(button)
func button_selected(id : int):
		succeed(id)

func close():
	clear()
	visible = false
	
func clear():
	for node in hbox_container.get_children():
		hbox_container.remove_child(node)
		node.queue_free()
func succeed(id : int):
	close()
	get_parent().get_parent().change_state(GameplayPage.GAMEPLAY_STATE.DIALOG)	
	dialogue_manager.start_inquiry_dialogue(current_npc, id)
	await dialogue_manager.dialogue_ended
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inquire") and get_parent().get_parent().current_state == GameplayPage.GAMEPLAY_STATE.INQUIRY_MENU:
		print_debug("exit inquire from _input")
		get_parent().get_parent().change_state(GameplayPage.GAMEPLAY_STATE.EXPLORE)	
		close()
		double_input_prevention()
		
func double_input_prevention() -> void:
	print('double input prevention')
	can_reopen = false
	await get_tree().create_timer(.1).timeout
	can_reopen = true
	
