# this is a copy of the tutorial.gd script + lvl2 related specifics. 
# we should probably do smthn smart like make this a singleton considering it only manages player state.
# we can do that later though I don't want to conflict too much w Owen
extends Node2D

@onready var panelArrangementScene = preload("res://src/clues/clue_arrange_screen.tscn")
@onready var player = $Player
@onready var cursor = $Cursor

enum GAMEPLAY_STATE{
	EXPLORE,
	DIALOG,
	PANEL_ARRANGE,
}

var current_state:GAMEPLAY_STATE = GAMEPLAY_STATE.EXPLORE
var panelArrangeInst
var overlapping_panel_name:String = ""

const PANEL_CENTERS = [
Vector2i(890,180),
Vector2i(1560,180),
Vector2i(867,726),
Vector2i(1305,510),
Vector2i(1717,510),
Vector2i(1560,878),
]

func _ready() -> void:
	for triggerArea:Area2D in $PanelTriggers.get_children():
		triggerArea.area_entered.connect(func(trigger): overlapping_panel_name = triggerArea.name)
		triggerArea.area_exited.connect(func(trigger): overlapping_panel_name = "")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:

		GAMEPLAY_STATE.EXPLORE:
			player.can_move = true
			cursor.can_move = false
			if Input.is_action_just_pressed("analyze"):
				current_state = GAMEPLAY_STATE.PANEL_ARRANGE
				_toggle_panel(overlapping_panel_name)
				#panelArrangeInst = panelArrangementScene.instantiate()	
				#panelArrangeInst.puzzle_solved.connect(_puzzle_solved)
				#add_child(panelArrangeInst)

		GAMEPLAY_STATE.DIALOG:
			player.can_move = false
			pass

		GAMEPLAY_STATE.PANEL_ARRANGE:
			player.can_move = false
			cursor.can_move = true
			if Input.is_action_just_pressed("analyze"):
				_toggle_panel(overlapping_panel_name)
				current_state = GAMEPLAY_STATE.EXPLORE
				#remove_child(panelArrangeInst)
			pass

func _toggle_panel(panel_number:String) -> void:
	if panel_number == "":
		return
	var panelCover:Polygon2D = $PanelCovers.get_node(panel_number)
	$Cursor.position = PANEL_CENTERS[int(panel_number)]
	$Cursor.visible = !$Cursor.visible
	panelCover.visible = !panelCover.visible 
