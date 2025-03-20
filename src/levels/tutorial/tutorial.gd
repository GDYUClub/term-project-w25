extends Node
class_name GameplayPage

#@onready var panelArrangementScene = $InventoryPanel
@onready var player = $Player
@onready var inventoryUi: =$InventoryUI
@onready var inventoryButton :TextureButton= $GameplayUI/Inventory

var point_click:bool = false 

enum GAMEPLAY_STATE{
	EXPLORE,
	DIALOG,
	PANEL_ARRANGE,
	CURSOR,
}

const PANEL_CENTERS = [
Vector2i(890,180),
Vector2i(1560,180),
Vector2i(867,726),
Vector2i(1305,510),
Vector2i(1717,510),
Vector2i(1560,878),
]

var current_state:GAMEPLAY_STATE = GAMEPLAY_STATE.EXPLORE
var panelArrangeInst
var overlapping_panel_name:String = ""

func _ready() -> void:
	if !$PanelTriggers:
		return
	for triggerArea:Area2D in $PanelTriggers.get_children():
		triggerArea.add_to_group("point_click")
		triggerArea.area_entered.connect(func(trigger): overlapping_panel_name = triggerArea.name)
		triggerArea.area_exited.connect(func(trigger): overlapping_panel_name = "")

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
		GAMEPLAY_STATE.CURSOR:
			player.can_move = false
			if Input.is_action_just_pressed("interact") and !$Cursor.interactable :
				_toggle_panel(overlapping_panel_name)
				current_state = GAMEPLAY_STATE.EXPLORE
			pass

# ran after a dialog sequence to check if a new item was added and toggles the prompt on the gameplay ui
func check_for_new_item():
	if Inventory.new_item_recieved:
		print('new item')
		Inventory.new_item_recieved = false
		inventoryButton.texture_normal = preload("res://assets/sprites/ui/Main_Gameplay_UI/invent_menu_button_new_item.png")

# only used in "point n click mode"
func _toggle_panel(panel_number:String) -> void:
	if panel_number == "":
		return
	var panelCover:Polygon2D = $PanelCovers.get_node(panel_number)
	$Cursor.position = PANEL_CENTERS[int(panel_number)]
	$Cursor.visible = !$Cursor.visible
	$Cursor.can_move = !$Cursor.can_move
	panelCover.visible = !panelCover.visible 

func change_to_cursor():
	if point_click:
		current_state = GAMEPLAY_STATE.CURSOR
		_toggle_panel(overlapping_panel_name)	

func reset_inventory_icon():
	inventoryButton.texture_normal = preload("res://assets/sprites/ui/Main_Gameplay_UI/invent_menu_button.png")
