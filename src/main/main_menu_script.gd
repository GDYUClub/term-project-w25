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
@onready var credits_menu = $CreditsMenu as CreditsMenuScreen


	#setting Menu
@onready var setting_menu = $SettingMenuv2
@onready var video_setting = $SettingMenuv2/SettingMenu/SettingContainer/VideoSetting
@onready var control_setting = $SettingMenuv2/SettingMenu/SettingContainer/ControlSetting
@onready var audio_setting = $SettingMenuv2/SettingMenu/SettingContainer/AudioSetting
@onready var acessbility_setting = $SettingMenuv2/SettingMenu/SettingContainer/AcessibilitySetting
@onready var video_button = $SettingMenuv2/SettingMenu/ButtonBox/Video
@onready var control_button = $SettingMenuv2/SettingMenu/ButtonBox/Control
@onready var audio_button = $SettingMenuv2/SettingMenu/ButtonBox/Audio
@onready var acessibility_button = $SettingMenuv2/SettingMenu/ButtonBox/Accessibility



# HANDLE CONNECTION
func _ready():
	$MainMenu/ButtonBox/VerticalButtonBox/GameStartButton.grab_focus()
	handle_connecting_signals()
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_down)
	setting_button.button_down.connect(on_setting_down)
	credits_button.button_down.connect(on_credits_down)
	quit_button.button_down.connect(on_quit_down)
	credits_menu.quit_credits_menu	.connect(on_quit_credits_menu)
	#setting
	video_button.button_down.connect(_on_video_setting_pressed)
	control_button.button_down.connect(_on_control_setting_pressed)
	audio_button.button_down.connect(_on_audio_setting_pressed)
	acessibility_button.button_down.connect(_on_acessibility_setting_pressed)



func on_start_down() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_quit_down() -> void:
	get_tree().quit()
	


## ALL CREDIT MENU FUCNTION
func on_credits_down() -> void:
	main_menu_margin_container.visible = false;
	credits_menu.set_process(true)
	credits_menu.visible = true;
	$CreditsMenu/CreditsMenuMargin/CreditsTitleBox/QuitButton.grab_focus()
func on_quit_credits_menu() -> void:
	main_menu_margin_container.visible = true;
	credits_menu.visible = false;
	$MainMenu/ButtonBox/VerticalButtonBox/CreditsButton.grab_focus()
	
## ALL SETTING MENU FUNCTION
func on_quit_setting_menu() -> void:
	main_menu_margin_container.visible = true;
	setting_menu.visible = false;
	$MainMenu/ButtonBox/VerticalButtonBox/SettingButton.grab_focus()
	
func on_setting_down() -> void:
	setting_menu.popup_centered()
	hide_settings()
	video_setting.show()
	
func hide_settings():
	video_setting.hide()
	audio_setting.hide()
	control_setting.hide()
	acessbility_setting.hide()
	
func _on_video_setting_pressed():
	hide_settings()
	video_setting.show()
func _on_control_setting_pressed():
	hide_settings()
	control_setting.show()
func _on_audio_setting_pressed():
	hide_settings()
	audio_setting.show()
func _on_acessibility_setting_pressed():
	hide_settings()
	acessbility_setting.show()
	
