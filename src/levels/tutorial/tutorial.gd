extends Node
class_name GameplayPage

#@onready var panelArrangementScene = $InventoryPanel
@onready var player = $Player
@onready var inventoryUi: =$InventoryUI
@onready var inventoryButton :TextureButton= $GameplayUI/Inventory

enum GAMEPLAY_STATE{
	EXPLORE,
	DIALOG,
	PANEL_ARRANGE,
}

var current_state:GAMEPLAY_STATE = GAMEPLAY_STATE.EXPLORE
var panelArrangeInst

func _puzzle_solved():
	$ColorRect.visible = false
	%BlockingShape.visible = false
	%BlockingShape.disabled = true
	inventoryUi.puzzle_solved.connect(_puzzle_solved)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:

		GAMEPLAY_STATE.EXPLORE:
			player.can_move = true
			if Input.is_action_just_pressed("analyze"):
				current_state = GAMEPLAY_STATE.PANEL_ARRANGE
				#panelArrangeInst = panelArrangementScene.instantiate()	
				inventoryUi.visible = true
				inventoryUi.do_ready()

		GAMEPLAY_STATE.DIALOG:
			player.can_move = false
			pass

		GAMEPLAY_STATE.PANEL_ARRANGE:
			player.can_move = false
			if Input.is_action_just_pressed("analyze"):
				current_state = GAMEPLAY_STATE.EXPLORE
				inventoryUi.visible = false
				reset_inventory_icon()
			pass

# ran after a dialog sequence to check if a new item was added and toggles the prompt on the gameplay ui
func check_for_new_item():
	if Inventory.new_item_recieved:
		print('new item')
		Inventory.new_item_recieved = false
		inventoryButton.texture_normal = preload("res://assets/sprites/ui/Main_Gameplay_UI/invent_menu_button_new_item.png")

func reset_inventory_icon():
	inventoryButton.texture_normal = preload("res://assets/sprites/ui/Main_Gameplay_UI/invent_menu_button.png")
