extends Node

@export var npc_name : String = ""
@export var start_index : int = 0
@export var end_index : int = 0
@export var character1_sprite : Texture
@export var character2_sprite : Texture
@export var can_talk : bool = true
@export var repeatable_conversation : bool
@export var can_inquiry : bool = true
@export var is_clue:bool
@onready var dialogue_manager: DialogueManager = %DialogueManager
var is_interacted_with : bool = false
signal interaction_over

func _ready() -> void:
	add_to_group("npc")

func talk_to_npc() -> void:
			if is_interacted_with != true and can_talk:
				if !repeatable_conversation:
					is_interacted_with = true
				dialogue_manager.load_npc_dialogue(start_index, end_index,character1_sprite,character2_sprite)
				await dialogue_manager.dialogue_ended
				interaction_over.emit()
