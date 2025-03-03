extends Node

@export var start_index : int = 0
@export var end_index : int = 0
@export var character1_sprite : Texture
@export var character2_sprite : Texture
@export var repeatable_conversation : bool
@export var dialogue_json_path:String

@onready var dialogue_manager: DialogueManager = %DialogueManager

var is_interacted_with : bool = false

func _ready() -> void:
	add_to_group("npc")

func talk_to_npc() -> void:
			if is_interacted_with != true:
				if !repeatable_conversation:
					is_interacted_with = true
				dialogue_manager.load_npc_dialogue(start_index, end_index,character1_sprite,character2_sprite,dialogue_json_path)
