extends Node

var _player_items: Array[Clue] = []

func add_item(c:Clue) -> void:
	_player_items.append(c)
	print(_player_items)
	pass

func remove_item(c:Clue) -> void:
	if c not in _player_items:
		return
	_player_items.remove_at(_player_items.find(c))

func clear_level_items(lvl_id:int) -> void:
	for item in _player_items:
		if item.lvl_id == lvl_id:
			_player_items.remove_at(_player_items.find(item))

func get_items() -> Array[Clue]:
	return _player_items


const CLUE_DB = {
0:"res://src/clues/clue-resources/tutorial/clue_cigs.tres",
1:"res://src/clues/clue-resources/tutorial/clue_lighter.tres",
2:"res://src/clues/clue-resources/tutorial/clue_third.tres",
}
