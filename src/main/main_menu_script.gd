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

	#credits menu
@onready var credits_menu = $CreditsMenuv2
@onready var programming_credits = $CreditsMenuv2/CreditsMenu/CreditsContainer/Programming
@onready var art_ui_credits = $CreditsMenuv2/CreditsMenu/CreditsContainer/Art_UI
@onready var writing_credits = $CreditsMenuv2/CreditsMenu/CreditsContainer/Writing
@onready var sound_design_credits = $CreditsMenuv2/CreditsMenu/CreditsContainer/Sound_Design
@onready var qa_credits = $CreditsMenuv2/CreditsMenu/CreditsContainer/QA
@onready var programming_button = $CreditsMenuv2/CreditsMenu/ButtonBox/Programming
@onready var art_ui_button = $CreditsMenuv2/CreditsMenu/ButtonBox/Art_UI
@onready var writing_button = $CreditsMenuv2/CreditsMenu/ButtonBox/Writing
@onready var sound_design_button = $CreditsMenuv2/CreditsMenu/ButtonBox/Sound_Design
@onready var qa_button = $CreditsMenuv2/CreditsMenu/ButtonBox/QA
@onready var credit_quit_button = $CreditsMenuv2/CreditsMenu/QuitButton

	#setting menu
@onready var setting_menu = $SettingMenuv2
@onready var video_setting = $SettingMenuv2/SettingMenu/SettingContainer/VideoSetting
@onready var control_setting = $SettingMenuv2/SettingMenu/SettingContainer/ControlSetting
@onready var audio_setting = $SettingMenuv2/SettingMenu/SettingContainer/AudioSetting
@onready var acessbility_setting = $SettingMenuv2/SettingMenu/SettingContainer/AcessibilitySetting
@onready var video_button = $SettingMenuv2/SettingMenu/ButtonBox/Video
@onready var control_button = $SettingMenuv2/SettingMenu/ButtonBox/Control
@onready var audio_button = $SettingMenuv2/SettingMenu/ButtonBox/Audio
@onready var acessibility_button = $SettingMenuv2/SettingMenu/ButtonBox/Accessibility
@onready var setting_quit_button = $SettingMenuv2/SettingMenu/QuitButton


# HANDLE CONNECTION
func _ready():
	$MainMenu/ButtonBox/VerticalButtonBox/GameStartButton.grab_focus()
	handle_connecting_signals()
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_down)
	setting_button.button_down.connect(on_setting_down)
	credits_button.button_down.connect(on_credits_down)
	quit_button.button_down.connect(on_quit_down)
	
	#credits
	programming_button.button_down.connect(_on_programming_credits_pressed)
	art_ui_button.button_down.connect(_on_art_ui_credits_pressed)
	writing_button.button_down.connect(_on_writing_credits_pressed)
	sound_design_button.button_down.connect(_on_sound_design_credits_pressed)
	qa_button.button_down.connect(_on_qa_credits_pressed)
	credit_quit_button.button_down.connect(_on_credits_quit_pressed)
	
	#setting
	video_button.button_down.connect(_on_video_setting_pressed)
	control_button.button_down.connect(_on_control_setting_pressed)
	audio_button.button_down.connect(_on_audio_setting_pressed)
	acessibility_button.button_down.connect(_on_acessibility_setting_pressed)
	setting_quit_button.button_down.connect(_on_setting_quit_pressed)



func on_start_down() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_quit_down() -> void:
	get_tree().quit()
	


## ALL CREDIT MENU FUCNTION
## ALL CREDIT MENU FUCNTION
func on_credits_down() -> void:
	credits_menu.popup_centered()
	hide_credits()
	programming_credits.show()
	$CreditsMenuv2/CreditsMenu/ButtonBox/Programming.grab_focus()
	
func hide_credits():
	programming_credits.hide()
	art_ui_credits.hide()
	writing_credits.hide()
	sound_design_credits.hide()
	qa_credits.hide()
	
func _on_programming_credits_pressed():
	hide_credits()
	programming_credits.show()
func _on_art_ui_credits_pressed():
	hide_credits()
	art_ui_credits.show()
func _on_writing_credits_pressed():
	hide_credits()
	writing_credits.show()
func _on_sound_design_credits_pressed():
	hide_credits()
	sound_design_credits.show()
func _on_qa_credits_pressed():
	hide_credits()
	qa_credits.show()
func _on_credits_quit_pressed():
	hide_credits()
	credits_menu.hide()
	
	

	
	
## ALL SETTING MENU FUNCTION
## ALL SETTING MENU FUNCTION
func on_quit_setting_menu() -> void:
	main_menu_margin_container.visible = true;
	setting_menu.visible = false;
	
func on_setting_down() -> void:
	setting_menu.popup_centered()
	hide_settings()
	video_setting.show()
	$SettingMenuv2/SettingMenu/ButtonBox/Video.grab_focus()
	
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
func _on_setting_quit_pressed():
	hide_settings()
	setting_menu.hide()
	
	
