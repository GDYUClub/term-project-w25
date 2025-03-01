extends CharacterBody2D

const SPEED: = 400.0
var can_move:= false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_move:
		return
	var dir:= Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = dir * SPEED 
	move_and_slide()
