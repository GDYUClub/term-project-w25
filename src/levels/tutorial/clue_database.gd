extends Node

@export var items : Array[Clue]
@export var itemDict : Dictionary = {}

func _ready() -> void:
	for item in items:
		itemDict[item.id] = item
