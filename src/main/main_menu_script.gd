class_name MainMenuScreen
extends Control

#main main
	#buttons
@onready var start_button = $MainMenu/ButtonBox/VerticalButtonBox/GameStartButton as Button
@onready var load_button = $MainMenu/ButtonBox/VerticalButtonBox/LoadGameButton as Button
@onready var setting_button = $MainMenu/ButtonBox/VerticalButtonBox/SettingButton as Button 
@onready var credits_button = $MainMenu/ButtonBox/VerticalButtonBox/CreditsButton as Button
@onready var quit_button = $MainMenu/ButtonBox/VerticalButtonBox/QuitButton as Button

	#levels and menus
@onready var start_level = preload("res://src/main/main.tscn") # preload the main scene and stor in memory
@onready var main_menu_margin_container = $MainMenu as MarginContainer
@onready var setting_menu = $SettingMenu as SettingMenuScreen
@onready var credits_menu = $CreditsMenu as CreditsMenuScreen


func _ready():
	$MainMenu/ButtonBox/VerticalButtonBox/GameStartButton.grab_focus()
	handle_connecting_signals()
	
func on_setting_down() -> void:
	main_menu_margin_container.visible = false;
	setting_menu.set_process(true)
	setting_menu.visible = true;
	$SettingMenu/SettingMenuMargin/SettingTitleBox/QuitButton.grab_focus()
	
func on_credits_down() -> void:
	main_menu_margin_container.visible = false;
	credits_menu.set_process(true)
	credits_menu.visible = true;
	$CreditsMenu/CreditsMenuMargin/CreditsTitleBox/QuitButton.grab_focus()

func on_start_down() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_quit_down() -> void:
	get_tree().quit()
	
func on_quit_setting_menu() -> void:
	main_menu_margin_container.visible = true;
	setting_menu.visible = false;
	$MainMenu/ButtonBox/VerticalButtonBox/SettingButton.grab_focus()
	
func on_quit_credits_menu() -> void:
	main_menu_margin_container.visible = true;
	credits_menu.visible = false;
	$MainMenu/ButtonBox/VerticalButtonBox/CreditsButton.grab_focus()
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_down)
	setting_button.button_down.connect(on_setting_down)
	credits_button.button_down.connect(on_credits_down)
	quit_button.button_down.connect(on_quit_down)
	setting_menu.quit_setting_menu	.connect(on_quit_setting_menu)
	credits_menu.quit_credits_menu	.connect(on_quit_credits_menu)
	
