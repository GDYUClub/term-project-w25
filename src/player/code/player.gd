extends CharacterBody2D

const WALK_SPEED = 300.0

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var alertSprite: Sprite2D = $AlertSprite
@onready var inquire_sprite: Sprite2D = $InquireSprite
@onready var area: Area2D = $Area2D

signal start_inquire
signal end_inquire

var can_move: bool = true

var interactable: Area2D = null

var clues: Array = []

enum MOVETYPES {
	TOP_DOWN,
	SIDE_SCROLLER,
}

var move_sprites = {
	MOVETYPES.TOP_DOWN: "res://assets/sprites/player/player_topdown.png",
	MOVETYPES.SIDE_SCROLLER: "res://assets/sprites/player/player_sidescroll.png",
}

var move_animations = {
	MOVETYPES.TOP_DOWN: "walk_topdown",
	MOVETYPES.SIDE_SCROLLER:"walk_sidescroll",
	}

var move_frames = {
	MOVETYPES.TOP_DOWN:3,
	MOVETYPES.SIDE_SCROLLER:6,
	}

@export var current_move_type: MOVETYPES

# Called when the node enters the scene tree for the first time.
#3
func _ready() -> void:
	add_to_group("player")
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)
	_change_move_type(current_move_type)
	if %PlayerStart:
		position = %PlayerStart.position


func _change_move_type(new_movetype: MOVETYPES):
	current_move_type = new_movetype
	velocity = Vector2.ZERO
	sprite.texture = load(move_sprites[current_move_type])
	sprite.hframes = move_frames[current_move_type]
	sprite.rotation = 0


func _top_down(delta: float):
	#var direction_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var rot_dir:= Input.get_axis("ui_left", "ui_right")
	sprite.rotation += rot_dir * 5 * delta
	var move_dir:= Input.get_axis("ui_up", "ui_down")
	var dir = Vector2(0,move_dir).rotated(sprite.rotation)
	velocity = WALK_SPEED * dir


# Side scroller movement function
func _side_scroller(delta: float):
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = WALK_SPEED * direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not can_move:
		return
	if current_move_type == MOVETYPES.TOP_DOWN:
		_top_down(delta)
	if current_move_type == MOVETYPES.SIDE_SCROLLER:
		_side_scroller(delta)
	if Input.is_action_just_pressed("interact"):
		interact()
	if Input.is_action_just_pressed("inquire"):
		inquire()
	_animate()
	move_and_slide()


func interact():
	if not interactable:
		return

	if interactable.is_in_group("clue"):
		#clue popup

		#get clue
		clues.append(interactable.clue)
		Inventory.add_item(interactable.clue)
		interactable.monitorable = false
		alertSprite.visible = false
		if interactable.clue.picks_up:
			interactable.visible = false

	if interactable.is_in_group("npc"):
		interactable.talk_to_npc()

func inquire():
	
	if not interactable or !interactable.is_in_group("npc") or interactable.can_inquiry == false:
		return
	if interactable.is_in_group("npc"):
		start_inquire.emit(interactable)

func _animate():
	if velocity != Vector2.ZERO:
		animPlayer.play(move_animations[current_move_type])
	else:
		animPlayer.stop()
		sprite.frame = 0


func _on_area_entered(area: Area2D):
	if area.is_in_group("clue"):
		alertSprite.visible = true
		interactable = area
	if area.is_in_group("npc"):
		if (area.is_interacted_with == false or area.repeatable_conversation == true) and area.can_talk == true:
			alertSprite.visible = true
			interactable = area
		if area.can_inquiry == true:
			inquire_sprite.visible = true
			interactable = area


func _on_area_exited(area: Area2D):
	if area.is_in_group("clue") or area.is_in_group("npc"):
		if area.is_in_group("npc"):
				end_inquire.emit()
		alertSprite.visible = false
		inquire_sprite.visible = false
		interactable = null
