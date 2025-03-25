extends Node2D

var current_page:int = 1
var current_panel :int= 1

@onready var camera:Camera2D = $Camera2D
const DEFAULT_SPEED = .2
const TWEEN_SPEED = .2
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
	var panel :Sprite2D= get_node("%d/Panels/%d" % [current_page, current_panel])
	var bubble :Sprite2D= get_node("%d/Bubbles/B%d" % [current_page, current_panel])
	var text :Label= get_node("%d/Text/L%d" % [current_page, current_panel])
	if panel == null:
		printerr("panel dosen't exist what are you even doing")
	panel.modulate = Color(1,1,1,0)
	var tween:Tween = get_tree().create_tween()

	if panel != null:
		tween.tween_property(panel,"modulate",Color(Color.WHITE),TWEEN_SPEED)
	
	if bubble != null:
		tween.parallel().tween_property(bubble,"modulate",Color(Color.WHITE),TWEEN_SPEED)

	if text != null:
		var text_color:Color = COLOR_MAP[PANEL_INFO[current_panel][0]]
		tween.parallel().tween_property(text,"modulate",Color(text_color),TWEEN_SPEED)

	await tween.finished
	if bubble
	

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
	for node in get_node("%d/Panels" % current_page).get_children():	
		node.modulate = Color(1,1,1,0)
	for node in get_node("%d/Bubbles" % current_page).get_children():	
		node.modulate = Color(1,1,1,0)
	for node in get_node("%d/Text" % current_page).get_children():	
		node.modulate = COLOR_MAP[PANEL_INFO[current_panel][0]]
		node.modulate.a = 0
