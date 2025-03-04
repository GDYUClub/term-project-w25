extends Node

var _player_items: Array[Clue] = []

func add_item(c:Clue) -> void:
	_player_items.append(c)
	pass

func remove_item(c:Clue) -> void:
	if c not in _player_items:
		return
	_player_items.remove_at(_player_items.find(c))

func clear_level_items(lvl_id) -> void:
	for item in _player_items:
		if item.lvl_id == lvl_id:
			_player_items.remove_at(_player_items.find(item))

func get_items() -> Array[Clue]:
	return _player_items
