extends CharacterBody2D

const SPEED: = 400.0
var can_move:= false
@onready var hitbox = $Area2D
# Called every frame. 'delta' is the elapsed time since the previous frame.

var interactable: Area2D = null

func _ready() -> void:
	hitbox.area_entered.connect(func(area): interactable = area)	
	hitbox.area_exited.connect(func(_area): interactable = null)	
	pass

func _process(delta: float) -> void:
	if !can_move:
		return
	if Input.is_action_just_pressed("interact"):
		_inspect()

	var dir:= Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = dir * SPEED 
	move_and_slide()

func _inspect() -> void:
	if interactable == null:
		return

	if interactable.is_in_group("npc") and !%Player.in_dialouge:
		%Player.in_dialouge = true
		interactable.talk_to_npc()
		await interactable.interaction_over
		%Player.in_dialouge = false
		get_parent().check_for_new_item()
		print("player in dialouge", %Player.in_dialouge)
