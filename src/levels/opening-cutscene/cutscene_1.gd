extends Node2D

const PAGES = 1
func _ready() -> void:
	pass

func hide_everything() -> void:
	for i in PAGES:
		var page = get_node("%d" % i)
		for panel_bundle in page.get_children():	
			var panel :Sprite2D= panel_bundle.get_node("Panel")
			var bubbleNode :Node2D= panel_bundle.get_node("Bubbles")
			var labelNode :Node2D= get_node("%d/%d/Text" )
			panel.modulate = Color(1,1,1,0)
			for bubble in bubbleNode.get_children():
				bubble.modulate = Color(1,1,1,0)
			for text in labelNode.get_children():
				text.modulate = Color(1,1,1,0)
