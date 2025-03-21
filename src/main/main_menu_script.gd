class_name MainMenuScreen
extends Control

#main main
	#buttons
@onready var start_button = $MainMenu/ButtonBox/VerticalButtonBox/GameStartButton as Button
@onready var load_button = $MainMenu/ButtonBox/VerticalButtonBox/LoadGameButton as Button
@onready var settings_button = $MainMenu/ButtonBox/VerticalButtonBox/SettingButton as Button 
@onready var credits_button = $MainMenu/ButtonBox/VerticalButtonBox/CreditsButton as Button
@onready var quit_button = $MainMenu/ButtonBox/VerticalButtonBox/QuitButton as Button

	#levels and menus
@onready var start_level = preload("res://src/levels/tutorial/tutorial-2.tscn") # preload the main scene and stor in memory
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
@onready var credits_quit_button = $CreditsMenuv2/CreditsMenu/QuitButton

	#setting menu
@onready var settings_menu = $SettingsMenuv2
@onready var video_settings = $SettingsMenuv2/SettingsMenu/SettingsContainer/VideoSettings
@onready var control_settings = $SettingsMenuv2/SettingsMenu/SettingsContainer/ControlSettings
@onready var audio_settings = $SettingsMenuv2/SettingsMenu/SettingsContainer/AudioSettings
@onready var acessbility_settings = $SettingsMenuv2/SettingsMenu/SettingsContainer/AcessibilitySettings
@onready var video_button = $SettingsMenuv2/SettingsMenu/ButtonBox/Video
@onready var control_button = $SettingsMenuv2/SettingsMenu/ButtonBox/Control
@onready var audio_button = $SettingsMenuv2/SettingsMenu/ButtonBox/Audio
@onready var acessibility_button = $SettingsMenuv2/SettingsMenu/ButtonBox/Accessibility
@onready var settings_quit_button = $SettingsMenuv2/SettingsMenu/QuitButton


# HANDLE CONNECTION
func _ready():
	$MainMenu/ButtonBox/VerticalButtonBox/GameStartButton.grab_focus()
	handle_connecting_signals()
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_down)
	settings_button.button_down.connect(on_settings_down)
	credits_button.button_down.connect(on_credits_down)
	quit_button.button_down.connect(on_quit_down)
	
	#credits
	programming_button.button_down.connect(_on_programming_credits_pressed)
	art_ui_button.button_down.connect(_on_art_ui_credits_pressed)
	writing_button.button_down.connect(_on_writing_credits_pressed)
	sound_design_button.button_down.connect(_on_sound_design_credits_pressed)
	qa_button.button_down.connect(_on_qa_credits_pressed)
	credits_quit_button.button_down.connect(_on_credits_quit_pressed)
	
	#settings
	video_button.button_down.connect(_on_video_settings_pressed)
	control_button.button_down.connect(_on_control_settings_pressed)
	audio_button.button_down.connect(_on_audio_settings_pressed)
	acessibility_button.button_down.connect(_on_acessibility_settings_pressed)
	settings_quit_button.button_down.connect(_on_settings_quit_pressed)


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
	
	

	
	
## ALL SETTINGS MENU FUNCTION
## ALL SETTINGS MENU FUNCTION
func on_quit_settings_menu() -> void:
	main_menu_margin_container.visible = true;
	settings_menu.visible = false;
	
func on_settings_down() -> void:
	settings_menu.popup_centered()
	hide_settings()
	video_settings.show()
	$SettingsMenuv2/SettingsMenu/ButtonBox/Video.grab_focus()
	
func hide_settings():
	video_settings.hide()
	audio_settings.hide()
	control_settings.hide()
	acessbility_settings.hide()
	
func _on_video_settings_pressed():
	hide_settings()
	video_settings.show()
func _on_control_settings_pressed():
	hide_settings()
	control_settings.show()
func _on_audio_settings_pressed():
	hide_settings()
	audio_settings.show()
func _on_acessibility_settings_pressed():
	hide_settings()
	acessbility_settings.show()
func _on_settings_quit_pressed():
	hide_settings()
	settings_menu.hide()
	
	
