class_name TextBox
extends MarginContainer

#const
const MAX_WIDTH = 256
#var
var current_text : String = ""
var letter_index : int = 0
var letter_time : float = 0.03

@onready var label: Label = $MarginContainer/Label
@onready var display_timer: Timer = $DisplayTimer

func _display_text(text: String): # takes in text string and will turn on autowrap if its larger then our MAX_WIDTH const
	letter_index = 0
	current_text = text
	label.text = text
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		custom_minimum_size.y = size.y
	else:
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.text = ""
	print("labeltext: "+ label.text)
	_display_letter()

func _display_letter(): # scrolls each letter until the end is reached where it will signal
	if letter_index < current_text.length():
		label.text += current_text[letter_index]
		letter_index += 1
		display_timer.start(letter_time)



func _on_display_timer_timeout() -> void: # recursive loop until all letters are in textbox
	_display_letter()
