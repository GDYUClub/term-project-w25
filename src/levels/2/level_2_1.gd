extends GameplayPage

const PANEL_CENTERS = [
Vector2i(890,180),
Vector2i(1560,180),
Vector2i(867,726),
Vector2i(1305,510),
Vector2i(1717,510),
Vector2i(1560,878),
]

var overlapping_panel_name:String = ""

func _ready() -> void:
	for triggerArea:Area2D in $PanelTriggers.get_children():
		triggerArea.area_entered.connect(func(trigger): overlapping_panel_name = triggerArea.name)
		triggerArea.area_exited.connect(func(trigger): overlapping_panel_name = "")

func _toggle_panel(panel_number:String) -> void:
	if panel_number == "":
		return
	var panelCover:Polygon2D = $PanelCovers.get_node(panel_number)
	$Cursor.position = PANEL_CENTERS[int(panel_number)]
	$Cursor.visible = !$Cursor.visible
	panelCover.visible = !panelCover.visible 
