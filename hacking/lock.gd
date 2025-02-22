extends Area2D

@onready var locked = true
@onready var game = $Popup


func open(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if locked:
			game.show()
		$Sprite2D.texture = load("res://assets/sprites/Chest 2 (1).png")

func _on_popup_close_requested() -> void:
	game.hide()
