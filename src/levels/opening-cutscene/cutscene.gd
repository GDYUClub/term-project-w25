extends Node2D

var current_page:int = 0
var current_panel :int= 0

@onready var camera:Camera2D = $Camera2D
const DEFAULT_SPEED = .2
const TWEEN_SPEED = .2
const PAGES = 1
# panels are 1 indexed so the first thing dosen't matter
# [x,y,z] x = color of text (0= white 1= black) y = delay until next panel, scroll_speed
const PANEL_INFO: = [
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
	[0,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,720],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,1080],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
	[1,DEFAULT_SPEED,0],
]
const COLOR_MAP: = {
	0:Color.WHITE,
	1:Color.BLACK
}

signal finished_scrolling
signal finished_rendering

func render_panel_bundle() -> void:
	var panel :Node2D= get_node("%d/%d/Panel" % [current_page, current_panel])
	var bubbleNode :Node2D= get_node("%d/%d/Bubbles" % [current_page, current_panel])
	var labelNode :Node2D= get_node("%d/%d/Text" % [current_page, current_panel])
	
	var bubbles :Array[Node]= bubbleNode.get_children()
	var labels:Array[Node]= labelNode.get_children()
	var tween:Tween = get_tree().create_tween()
	
	tween.tween_property(panel,"modulate",Color(Color.WHITE),TWEEN_SPEED)
	
	await tween.finished

	while !bubbles.is_empty():
		var bubble :Sprite2D = bubbles.pop_front()
		var text :Label = labels.pop_front()
		tween.tween_property(bubble,"modulate",Color(Color.WHITE),TWEEN_SPEED)

		var text_color:Color = COLOR_MAP[PANEL_INFO[current_panel][0]]
		tween.parallel().tween_property(text,"modulate",Color(text_color),TWEEN_SPEED)

		await tween.finished

	

func _ready() -> void:
	hide_everything()
	while true:
		print(current_panel)
		await render_panel_bundle()
		await get_tree().create_timer(PANEL_INFO[current_panel][1]).timeout
		if PANEL_INFO[current_panel][2] != 0:
			scroll_down() 
		current_panel += 1
		if current_panel == PANEL_INFO.size():
			break

func scroll_down() -> void:
	print('scrolling')
	var tween:Tween = get_tree().create_tween()
	var y_offset :int= PANEL_INFO[current_panel][2]
	tween.tween_property(camera,"global_position",camera.global_position + Vector2(0,y_offset),1)
	await tween.finished

func _process(delta: float) -> void:
	pass

func hide_everything() -> void:
	print(PANEL_INFO.size())
	for i in PAGES:
		var page = get_node("%d" % i)
		for panel_bundle in page.get_children():	
			var panel :Sprite2D= panel_bundle.get_node("Panel")
			var bubbleNode :Node2D= get_node("%d/%d/Bubbles" % [current_page, current_panel])
			var labelNode :Node2D= get_node("%d/%d/Text" % [current_page, current_panel])
			panel.modulate = Color(1,1,1,0)
			for bubble in bubbleNode.get_children():
				bubble.modulate = Color(1,1,1,0)
			for text in labelNode.get_children():
				text.modulate = Color(1,1,1,0)

	# for node in get_node("%d/Panels" % current_page).get_children():	
	# 	node.modulate = Color(1,1,1,0)
	# for node in get_node("%d/Bubbles" % current_page).get_children():	
	# 	node.modulate = Color(1,1,1,0)
	# for node in get_node("%d/Text" % current_page).get_children():	
	# 	node.modulate = COLOR_MAP[PANEL_INFO[current_panel][0]]
	# 	node.modulate.a = 0
