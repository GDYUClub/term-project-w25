class_name SettingMenuScreen
extends Control

@onready var quit_button = $SettingMenuMargin/SettingTitleBox/QuitButton as Button


signal quit_setting_menu

func _ready():
	quit_button.button_down.connect(on_quit_setting_menu_down)
	set_process(false) #stops processing so buttons won't appear when switching back to main menu


func on_quit_setting_menu_down() -> void:
	quit_setting_menu.emit()
	set_process(false)
