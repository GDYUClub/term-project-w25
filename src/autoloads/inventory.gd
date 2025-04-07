extends Node

var _player_items: Array[Clue] = []
var new_item_recieved:bool = false

func add_item(c:Clue) -> void:
	if c in _player_items:
		return
	new_item_recieved = true
	_player_items.append(c)
	print(_player_items)

func remove_item(c:Clue) -> void:
	if c not in _player_items:
		return
	_player_items.remove_at(_player_items.find(c))

func clear_level_items(lvl_id:int) -> void:
	for item in _player_items:
		print("is item?",item.name,item.lvl_id,lvl_id)
		if item.lvl_id == lvl_id:
			_player_items.remove_at(_player_items.find(item))


func clear_all() -> void:
	_player_items = []


func get_items() -> Array[Clue]:
	return _player_items

func is_empty() -> bool:
	return _player_items.is_empty()

func get_item_count() -> int:
	return _player_items.size()
const CLUE_DB = {
0:"res://src/clues/clue-resources/tutorial/shattered_glass.tres",
1:"res://src/clues/clue-resources/tutorial/lighter.tres",
2:"res://src/clues/clue-resources/tutorial/clue_third.tres",
}
