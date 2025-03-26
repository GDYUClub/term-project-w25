extends Node2D

const ANIMATIONS = ["page1","page2","page3","page4","page5"] 
#const ANIMATIONS = ["page3","page2"] 
@onready var animPlayer :AnimationPlayer = $AnimationPlayer
@onready var ref :Sprite2D= $reference

func _ready() -> void:
	hide_everything()
	for i in range(5):
		var panel :Node2D = get_node("%d" % i)
		panel.visible = true
		animPlayer.play(ANIMATIONS[i])
		await animPlayer.animation_finished
		panel.visible = false

	pass

func hide_everything():
	ref.visible = false
	for i in range(5):
		var panel :Node2D = get_node("%d" % i)
		panel.visible = false
