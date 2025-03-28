extends Node

@export var items : Array[Clue]
@export var itemDict : Dictionary = {}

func _ready() -> void:
	for item in items:
		if item.id in itemDict:
			push_error("duplicate clue id")
		itemDict[item.id] = item
