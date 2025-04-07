extends CharacterBody2D

const SPEED: = 400.0
var can_move:= false
var close_cooled = true
@onready var hitbox = $Area2D
@onready var player = %Player
# Called every frame. 'delta' is the elapsed time since the previous frame.

var interactable: Area2D = null

func _ready() -> void:
	hitbox.area_entered.connect(
	func(area): 
		if area.is_in_group("npc"):
			player.interactable = area
			%AlertSprite.visible = true
	)	
	hitbox.area_exited.connect(
	func(area): 
		if area.is_in_group("npc"):
			player.interactable = null
			%AlertSprite.visible = false
	)	

func _process(delta: float) -> void:
	if !can_move:
		return
	if Input.is_action_just_pressed("interact"):
		if close_cooled:
			player.interact()

	var dir:= Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = dir * SPEED 
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and get_parent().current_state == GameplayPage.GAMEPLAY_STATE.CURSOR:
		player.interact()
		get_viewport().set_input_as_handled()


func double_input_prevention():
	close_cooled = false
	await get_tree().create_timer(0.1).timeout
	close_cooled = true
