extends Node2D

const ANIMATIONS = ["page1","page2","page3","page4","page5"] 
const VOICE_LINES = [preload("res://assets/sound/voice/page1.ogg"),preload("res://assets/sound/voice/page2.ogg"),preload("res://assets/sound/voice/page3.ogg"),preload("res://assets/sound/voice/page4.ogg"),preload("res://assets/sound/voice/page5.ogg")]
#const ANIMATIONS = ["page3","page2"] 
@onready var animPlayer :AnimationPlayer = $AnimationPlayer
@onready var ref :Sprite2D= $reference

func _ready() -> void:
	AudioManager.play_music(preload("res://assets/sound/bgm/office-theme.ogg"))
	hide_everything()
	for i in range(5):
		var panel :Node2D = get_node("%d" % i)
		panel.visible = true
		animPlayer.play(ANIMATIONS[i])
		AudioManager.play_sfx(VOICE_LINES[i])
		await animPlayer.animation_finished
		panel.visible = false
	get_tree().change_scene_to_file("res://src/levels/tutorial/tutorial-1.tscn")


func hide_everything():
	ref.visible = false
	for i in range(5):
		var panel :Node2D = get_node("%d" % i)
		panel.visible = false
