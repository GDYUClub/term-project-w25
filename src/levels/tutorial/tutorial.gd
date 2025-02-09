extends Node

@onready var panelArrangementScene = preload("res://src/clues/clue_grid_testing.tscn")

enum GAMEPLAY_STATE{
	EXPLORE,
	DIALOG,
	PANEL_ARRANGE,
}

var current_state:GAMEPLAY_STATE = GAMEPLAY_STATE.EXPLORE
var panelArrangeInst

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		GAMEPLAY_STATE.EXPLORE:
			if Input.is_action_just_pressed("analyze"):
				current_state = GAMEPLAY_STATE.PANEL_ARRANGE
				panelArrangeInst = panelArrangementScene.instantiate()	
				add_child(panelArrangeInst)
		GAMEPLAY_STATE.DIALOG:
			pass
		GAMEPLAY_STATE.PANEL_ARRANGE:
			if Input.is_action_just_pressed("analyze"):
				current_state = GAMEPLAY_STATE.EXPLORE
				remove_child(panelArrangeInst)
			pass
