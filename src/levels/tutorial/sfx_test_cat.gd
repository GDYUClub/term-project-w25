extends Area2D

func _ready() -> void:
	area_entered.connect(
	func(_area:Area2D) -> void:
		AudioManager.play_sfx(preload("res://assets/sound/sfx/lighter_sfx.ogg"))	
	)
	pass
