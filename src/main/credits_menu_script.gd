class_name CreditsMenuScreen
extends Control

@onready var quit_button = $CreditsMenuMargin/CreditsTitleBox/QuitButton as Button


signal quit_credits_menu

func _ready():
	quit_button.button_down.connect(on_quit_credits_menu_down)
	set_process(false) #stops processing so buttons won't appear when switching back to main menu


func on_quit_credits_menu_down() -> void:
	quit_credits_menu.emit()
	set_process(false)
