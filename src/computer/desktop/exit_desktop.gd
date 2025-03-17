extends Node2D

@export var sprite: Sprite2D

var exit_active: bool = false

func icon_selected(value: bool) -> void:
	exit_active = value
	sprite.material.set_shader_parameter("effect_enabled", value)
