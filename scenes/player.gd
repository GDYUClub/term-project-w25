extends CharacterBody2D

@onready var cshape = $CollisionShape2D

const WALK_SPEED = 80.0
const CLIMB_SPEED = 50.0
const SPRINT_SPEED = 120.0
const CROUCH_SPEED = 65.0

@export var move_type: bool = false # Top-down or Side-scroller. Defaulted to top-down

var on_ladder: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_crouching: bool = false
@export var hold_to_crouch: bool = false # Handles press or hold-to-crouch behavior. Currently unimplemented

var stand_cshape = preload("res://assets/resources/standing_cshape.tres")
var crouch_cshape = preload("res://assets/resources/crouch_cshape.tres")

#------------------------------------------------
# Top down movement function
func _top_down():
	
	var direction := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_up", "ui_down")
	
	if directionY:
		velocity.y = directionY * WALK_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, WALK_SPEED)

	if direction:
		if is_crouching:
			velocity.x = direction * CROUCH_SPEED
		else:
			velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)

	if Input.is_action_pressed("ui_sprint"): # Controls sprint speed depending on player state
		if is_crouching:
			velocity.x = direction * WALK_SPEED
			velocity.y = directionY * WALK_SPEED
		else:
			velocity.x = direction * SPRINT_SPEED
			velocity.y = directionY * SPRINT_SPEED
#------------------------------------------------		

#------------------------------------------------
# Side scroller movement function
func _side_scroller(delta: float):
	if not is_on_floor() and !on_ladder:
		velocity.y += gravity * delta
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if is_crouching:
			velocity.x = direction * CROUCH_SPEED
		else:
			velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)

	if Input.is_action_pressed("ui_sprint"):
		if is_crouching:
			velocity.x = direction * WALK_SPEED
		else:
			velocity.x = direction * SPRINT_SPEED

	if on_ladder: # Enables climbing behavior if player is on a ladder
		_climb()
#------------------------------------------------		

#------------------------------------------------
# Climb ladder function
func _climb():
	var directionY := Input.get_axis("ui_up", "ui_down")
	if directionY: # Move up or down a ladder, no horizontal movement while climbing
		velocity.y = directionY * CLIMB_SPEED
		velocity.x = 0
	else:
		velocity.y = 0

	if Input.is_action_pressed("ui_sprint"): # Controls sprint speed while climbing. Quick descend and slow ascend
		if directionY > 0:
			velocity.y = directionY * SPRINT_SPEED
		if directionY < 0:
			velocity.y = directionY * SPRINT_SPEED/2
#------------------------------------------------

#------------------------------------------------
# Crouch function
func _crouch():
	if !is_crouching:
		is_crouching = true
		cshape.shape = crouch_cshape
	else:
		is_crouching = false
		cshape.shape = stand_cshape
#------------------------------------------------


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept"):
		move_type = !move_type
	
	if Input.is_action_just_pressed("crouch"):
		
		_crouch()
	
	if move_type == false:
		_top_down()
		print("Top down movement mode")
	else:
		_side_scroller(delta)
		print("Side-scroller movement mode")

	print(on_ladder)
	
	move_and_slide()
