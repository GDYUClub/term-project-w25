extends Control

func _ready() -> void:
	%StartBtn.grab_focus()
	
	%StartBtn.focus_entered.connect(
	func():
		%JaneTexture.texture = preload("res://assets/sprites/title-screen/Title-20250405T032620Z-001/Title/Title_Jane_Start.png")
			)
	
	%StartBtn.pressed.connect(
		func():
			get_tree().change_scene_to_packed(preload("res://src/levels/opening-cutscene/cutscene.tscn"))
	)

	%OptionsBtn.focus_entered.connect(
	func():
		%JaneTexture.texture = preload("res://assets/sprites/title-screen/Title-20250405T032620Z-001/Title/Title_Jane_Settings.png")
	)
	%CreditBtn.focus_entered.connect(
	func():
		%JaneTexture.texture = preload("res://assets/sprites/title-screen/Title-20250405T032620Z-001/Title/Title_Jane_Credits.png")
	)

	%CreditBtn.pressed.connect(
	func():
		get_tree().change_scene_to_packed(preload("res://src/main/credits.tscn"))
	)

	%QuitBtn.focus_entered.connect(
	func():
		%JaneTexture.texture = preload("res://assets/sprites/title-screen/Title-20250405T032620Z-001/Title/Title_Jane_Quit.png")
	)
	%QuitBtn.pressed.connect(
	func():
		get_tree().quit()
	)







	
