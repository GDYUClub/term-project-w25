extends Popup

@onready var bar = $hackbar


func play():
	if bar.on_Hackbar_pressed():
		get_parent().locked = false
		hide()
