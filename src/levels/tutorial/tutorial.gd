extends Node

@onready var panelArrangementScene = preload("res://src/clues/clue_grid_testing.tscn")
@onready var player = $Player

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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:

		GAMEPLAY_STATE.EXPLORE:
			player.can_move = true
			if Input.is_action_just_pressed("analyze"):
				current_state = GAMEPLAY_STATE.PANEL_ARRANGE
				panelArrangeInst = panelArrangementScene.instantiate()	
				panelArrangeInst.puzzle_solved.connect(_puzzle_solved)
				add_child(panelArrangeInst)

		GAMEPLAY_STATE.DIALOG:
			player.can_move = false
			pass

		GAMEPLAY_STATE.PANEL_ARRANGE:
			player.can_move = false
			if Input.is_action_just_pressed("analyze"):
				current_state = GAMEPLAY_STATE.EXPLORE
				remove_child(panelArrangeInst)
			pass
