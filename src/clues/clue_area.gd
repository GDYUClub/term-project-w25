extends Area2D

@export var clue: Clue
@onready var sprite = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("clue")
	area_entered.connect(_on_area_entered)
	sprite.texture = clue.environment_sprite


func _on_area_entered(area: Area2D):
	pass
