extends Node

@export var start_index : int = 0
@export var end_index : int = 0
@export var textboxes : Array[TextBox]
@onready var dialogue_manager: DialogueManager = %DialogueManager


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("start_dialogue") && (dialogue_manager.dialogue_ongoing == false)):
		dialogue_manager.load_dialogue(start_index,end_index, textboxes)
		
