extends CharacterBody2D

const WALK_SPEED = 300.0

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var alertSprite: Sprite2D = $AlertSprite
@onready var inquire_sprite: Sprite2D = $InquireSprite
@onready var area: Area2D = $Area2D
@onready var sceneAnimPlayer:AnimationPlayer = get_parent().get_node("AnimationPlayer")

@export_range(0,1) var starting_scale:float

signal start_inquire
signal end_inquire

var in_dialouge := false

var can_move: bool = true

var interactable: Area2D = null

var clues: Array = []

enum MOVETYPES {
	TOP_DOWN,
	SIDE_SCROLLER,
}

var move_sprites = {
	MOVETYPES.TOP_DOWN: "res://assets/sprites/player/player_topdown.png",
	MOVETYPES.SIDE_SCROLLER: "res://assets/sprites/player/side_1080.png",
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

const is_clue_alert_texture:={
false:preload("res://assets/sprites/ui/Main_Gameplay_UI/npc_dialogue_static-already_spoken.png"),
true:preload("res://assets/sprites/ui/Main_Gameplay_UI/interactable_notif.png"),
}

# Called when the node enters the scene tree for the first time.
#3

func change_scale(new_scale:float):
	sprite.scale = Vector2(new_scale,new_scale)
	pass

func _ready() -> void:
	add_to_group("player")
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)
	_change_move_type(current_move_type)
	change_scale(starting_scale)
	if %PlayerStart:
		position = %PlayerStart.position


func _change_move_type(new_movetype: MOVETYPES):
	current_move_type = new_movetype
	velocity = Vector2.ZERO
	sprite.texture = load(move_sprites[current_move_type])
	sprite.hframes = move_frames[current_move_type]
	sprite.rotation = 0


func _top_down(delta: float):
	var rot_dir:= Input.get_axis("ui_left", "ui_right")
	sprite.rotation += rot_dir * 5 * delta
	var move_dir:= Input.get_axis("ui_up", "ui_down")
	var dir = Vector2(0,move_dir).rotated(sprite.rotation)
	velocity = WALK_SPEED * dir


# Side scroller movement function
func _side_scroller(delta: float):
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = WALK_SPEED * direction
	if direction == 1:
		sprite.flip_h = false
	if direction == -1:
		sprite.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not can_move:
		return
	if current_move_type == MOVETYPES.TOP_DOWN:
		_top_down(delta)
	if current_move_type == MOVETYPES.SIDE_SCROLLER:
		_side_scroller(delta)
	for overlap in area.get_overlapping_areas():
		_on_area_entered(overlap)
		
	# if Input.is_action_just_pressed("interact"):
	# 	interact()
	# if Input.is_action_just_pressed("inquire") and get_parent().current_state == GameplayPage.GAMEPLAY_STATE.EXPLORE:
	# 	print_debug("run inquire from process")
	# 	inquire()
	
	_animate()
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and get_parent().current_state == GameplayPage.GAMEPLAY_STATE.EXPLORE:
		interact()
	if event.is_action_pressed("inquire") and get_parent().current_state == GameplayPage.GAMEPLAY_STATE.EXPLORE:
		print_debug("run inquire from process")
		if %InquireUI.can_reopen:
			inquire()
	
func interact():
	if not interactable or in_dialouge:
		return
	print(interactable.get_groups())
	if interactable.is_in_group("clue"):
		clues.append(interactable.clue)
		Inventory.add_item(interactable.clue)
		interactable.monitorable = false
		alertSprite.visible = false
		if interactable.clue.picks_up:
			interactable.visible = false

	elif interactable.is_in_group("npc"):
		in_dialouge = true
		#can_move = false
		get_parent().change_state(GameplayPage.GAMEPLAY_STATE.DIALOG)
		interactable.talk_to_npc()
		await interactable.interaction_over
		interactable = null
		#can_move = true
		get_parent().change_state(GameplayPage.GAMEPLAY_STATE.EXPLORE)
		get_parent().check_for_new_item()
	
	elif interactable.is_in_group("point_click"):
		get_parent().change_to_cursor()
	
	elif interactable.is_in_group("elevator"):
		if position.y > 1600:
			sceneAnimPlayer.play("elevator_up")
		else:
			sceneAnimPlayer.play("elevator_down")

	elif interactable.is_in_group("streetcar"):
		sceneAnimPlayer.play("street car leaves")
		await sceneAnimPlayer.animation_finished
		%StreetCarBlock.disabled = true


func inquire():
	if not interactable or !interactable.is_in_group("npc") or interactable.can_inquiry == false:
		return
	if (get_parent().current_state == GameplayPage.GAMEPLAY_STATE.INQUIRY_MENU):
		print('inquiein')
	if interactable.is_in_group("npc"):
		get_parent().change_state(GameplayPage.GAMEPLAY_STATE.INQUIRY_MENU)
		start_inquire.emit(interactable)
		await interactable.inquiry_over
		get_parent().change_state(GameplayPage.GAMEPLAY_STATE.EXPLORE)
		get_parent().check_for_new_item()


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
		alertSprite.texture = is_clue_alert_texture[area.is_clue]
		if (area.is_interacted_with == false or area.repeatable_conversation == true) and area.can_talk == true:
			alertSprite.visible = true
			interactable = area
		if area.can_inquiry == true:
			inquire_sprite.visible = true
			interactable = area
	if area.is_in_group("point_click"):
		alertSprite.texture = is_clue_alert_texture[true]
		alertSprite.visible = true
		interactable = area
	if area.is_in_group("elevator") or area.is_in_group("streetcar"):
		alertSprite.texture = is_clue_alert_texture[true]
		alertSprite.visible = true
		interactable = area

func _on_area_exited(area: Area2D):
	if area.is_in_group("clue") or area.is_in_group("npc") or area.is_in_group("point_click") or area.is_in_group("elevator") or area.is_in_group("streetcar"):
		if area.is_in_group("npc"):
				end_inquire.emit()
		alertSprite.visible = false
		inquire_sprite.visible = false
		interactable = null
