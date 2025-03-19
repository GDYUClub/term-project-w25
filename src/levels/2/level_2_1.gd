extends GameplayPage

const PANEL_CENTERS = [
Vector2i(890,180),
Vector2i(1560,180),
Vector2i(867,726),
Vector2i(1305,510),
Vector2i(1717,510),
Vector2i(1560,878),
]

func _toggle_panel(panel_number:String) -> void:
	if panel_number == "":
		return
	var panelCover:Polygon2D = $PanelCovers.get_node(panel_number)
	$Cursor.position = PANEL_CENTERS[int(panel_number)]
	$Cursor.visible = !$Cursor.visible
	panelCover.visible = !panelCover.visible 
