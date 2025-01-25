extends CharacterBody2D

@onready var cshape = $CollisionShape2D

const WALK_SPEED = 80.0
const CLIMB_SPEED = 50.0
const SPRINT_SPEED = 120.0
const CROUCH_SPEED = 65.0


@export var move_type := MoveType.TOP_DOWN

enum MoveType {
	TOP_DOWN,
	SIDE_SCROLLER
}

var on_ladder: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_crouching: bool = false
var hold_to_crouch: bool = false # Handles press or hold-to-crouch behavior. Currently unimplemented

var stand_cshape = preload("res://assets/resources/standing_cshape.tres")
var crouch_cshape = preload("res://assets/resources/crouch_cshape.tres")

# Top down movement function
func _top_down():
	
	
	var direction_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	velocity.y = direction_vector.y * WALK_SPEED if direction_vector.y else move_toward(velocity.y, 0, WALK_SPEED)
	
	velocity.x = direction_vector.x * (CROUCH_SPEED if is_crouching else WALK_SPEED) if direction_vector.x else move_toward(velocity.x, 0, WALK_SPEED)
	
	velocity.x = direction_vector.x * (WALK_SPEED if is_crouching else SPRINT_SPEED) if Input.is_action_pressed("sprint") else velocity.x
	velocity.y = direction_vector.y * (WALK_SPEED if is_crouching else SPRINT_SPEED) if Input.is_action_pressed("sprint") else velocity.y


# Side scroller movement function
func _side_scroller(delta: float):
	if not is_on_floor() and !on_ladder:
		velocity.y += gravity * delta
	
	var direction := Input.get_axis("ui_left", "ui_right")

	velocity.x = direction * (CROUCH_SPEED if is_crouching else WALK_SPEED) if direction else move_toward(velocity.x, 0, WALK_SPEED)

	velocity.x = direction * (WALK_SPEED if is_crouching else SPRINT_SPEED) if Input.is_action_pressed("sprint") else velocity.x

	if on_ladder: # Enables climbing behavior if player is on a ladder
		_climb()

# Climb ladder function
func _climb():
	var directionY := Input.get_axis("ui_up", "ui_down")
	
	velocity.y = directionY * CLIMB_SPEED if directionY else 0
	velocity.x = 0 if directionY else velocity.x
	
	velocity.y = directionY * (SPRINT_SPEED if directionY > 0 else SPRINT_SPEED / 2) if Input.is_action_pressed("sprint") and directionY != 0 else velocity.y


# Crouch function
func _crouch():
	is_crouching = true if !is_crouching else false
	cshape.shape = crouch_cshape if is_crouching else stand_cshape


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("crouch"):
		_crouch()
	if move_type == MoveType.TOP_DOWN:
		_top_down()
		print("Top down movement mode")
	else:
		_side_scroller(delta)
		print("Side-scroller movement mode")

	print(on_ladder)
	
	move_and_slide()
