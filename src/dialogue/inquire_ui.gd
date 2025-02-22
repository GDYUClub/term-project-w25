extends Control

@export var clue_button_scene : PackedScene = preload("res://src/dialogue/clue_button.tscn")
var correct_id : int

func start_inquire(npc):
	visible = true
	correct_id = npc.inquiry_clue
	for clue in Inventory.get_items():
		create_button(clue)

func create_button(clue: Clue):
	var button : Button = clue_button_scene.instantiate()
	button.icon = clue.icon
	button.pressed.connect(button_selected.bind(clue.id))
	
func button_selected(id : int):
	if id != correct_id:
		fail()
	else:
		succeed()

func fail():
	for n in get_children():
		remove_child(n)
		n.queue_free()
	visible = false
	
func succeed():
	pass
	
