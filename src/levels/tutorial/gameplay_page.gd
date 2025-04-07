extends Node
class_name GameplayPage

#@onready var panelArrangementScene = $InventoryPanel
@onready var player = $Player
@onready var inventoryUi: =%InventoryUI
@onready var inventoryButton :TextureButton= %GameplayUI/Inventory

@export var page:PAGES

var jane_sprite: Texture = preload("res://assets/sprites/player/Vanessa_jane_threequarterview_small.png")

enum PAGES{
page1_1,
page1_2,
page2_1_1,
page2_1_2,
page2_2,
}

var point_click:bool = false 

var can_progress:bool = false

enum GAMEPLAY_STATE{
	EXPLORE,
	DIALOG,
	PANEL_ARRANGE,
	CURSOR,
	INQUIRY_MENU
}

var PANEL_CENTERS = [
Vector2i(890,180),
Vector2i(1400,180),
Vector2i(867,726),
Vector2i(1305,510),
Vector2i(1300,510),
Vector2i(1400,878),
]

var current_state:GAMEPLAY_STATE = GAMEPLAY_STATE.EXPLORE
var panelArrangeInst
var overlapping_panel_name:String = ""
var found_all_2_1_items = false

func _ready() -> void:
	play_level_theme()
	set_inventory()
	#%DialogueManager.solved_page_puzzle.connect(_solved_clues)
	%DialogueManager.dialogue_event.connect(_handle_dialouge_event)
	if !$PanelTriggers:
		return
	for triggerArea:Area2D in $PanelTriggers.get_children():
		triggerArea.add_to_group("point_click")
		triggerArea.area_entered.connect(func(trigger): overlapping_panel_name = triggerArea.name)
		triggerArea.area_exited.connect(func(trigger): overlapping_panel_name = "")

func collected_everything_check():
	# checks if you got all the items in 2-1-1
	var merged_clues = [preload("res://src/clues/clue-resources/level2/level2-1/mergeresults/Attack.tres"),preload("res://src/clues/clue-resources/level2/level2-1/mergeresults/BottleHit.tres"),preload("res://src/clues/clue-resources/level2/level2-1/mergeresults/BrokenPanel.tres"),preload("res://src/clues/clue-resources/level2/level2-1/mergeresults/Talk.tres")]
	if page == PAGES.page2_1_2:
		for clue:Clue in merged_clues:
			if Inventory.has_item(clue) == false:
				print_debug("missing: " + clue.name)
				return false
		return true
	
	if page == PAGES.page2_1_1:
		for clue:Clue in %ClueDatabase.items:
			if clue.type != Clue.Type.NORMAL:
				continue
			if Inventory.has_item(clue) == false:
				print_debug("missing: " + clue.name)
				return false
		return true

	return false

func set_inventory():
	match page:
		PAGES.page1_1:
			Inventory._player_items = []
		PAGES.page1_2:
			Inventory._player_items = []
		PAGES.page2_1_1:
			Inventory._player_items = []
			Inventory.add_item(preload("res://src/clues/clue-resources/tutorial/head_trauma.tres"))
			Inventory.add_item(preload("res://src/clues/clue-resources/tutorial/shattered_glass.tres"))
			Inventory.add_item(preload("res://src/clues/clue-resources/tutorial/gun_holster.tres"))
		PAGES.page2_1_2:
			#var prev_inventory = Inventory._player_items
			Inventory._player_items = []
			Inventory.add_item(preload("res://src/clues/clue-resources/tutorial/head_trauma.tres"))
			Inventory.add_item(preload("res://src/clues/clue-resources/tutorial/shattered_glass.tres"))
			Inventory.add_item(preload("res://src/clues/clue-resources/tutorial/gun_holster.tres"))
			for clue:Clue in %PrevClueDatabase.items:
				Inventory.add_item(clue)
			# if Inventory.has_item(preload("res://src/clues/clue-resources/level2/level2-1/mergeresults/Attack.tres")):
			# 	Inventory.remove_item(preload("res://src/clues/clue-resources/tutorial/gun_holster.tres"))
			# 	Inventory.remove_item(preload("res://src/clues/clue-resources/level2/level2-1/panel1/pen.tres"))
			#
		PAGES.page2_2:
			Inventory._player_items = []


func play_level_theme():
	var song:AudioStream
	match page:
		PAGES.page1_1:
			song = preload("res://assets/sound/bgm/Crime Scene theme.ogg")
		PAGES.page1_2:
			song = preload("res://assets/sound/bgm/Crime Scene theme.ogg")
		PAGES.page2_1_1:
			song = preload("res://assets/sound/bgm/house-theme.ogg")
		PAGES.page2_1_2:
			song = preload("res://assets/sound/bgm/house-theme.ogg")
		PAGES.page2_2:
			song = preload("res://assets/sound/bgm/party_theme.ogg")

	AudioManager.play_music(song)


func _puzzle_solved():
	$ColorRect.visible = false
	%BlockingShape.visible = false
	%BlockingShape.disabled = true
	inventoryUi.puzzle_solved.connect(_puzzle_solved)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:

		GAMEPLAY_STATE.EXPLORE:
			player.can_move = true
			if Input.is_action_just_pressed("analyze"):
				change_state(GAMEPLAY_STATE.PANEL_ARRANGE)
				#panelArrangeInst = panelArrangementScene.instantiate()	
				inventoryUi.visible = true
				inventoryUi.do_ready()

		GAMEPLAY_STATE.DIALOG:
			player.can_move = false
			pass

		GAMEPLAY_STATE.INQUIRY_MENU:
			player.can_move = false
			pass

		GAMEPLAY_STATE.PANEL_ARRANGE:
			player.can_move = false
			if Input.is_action_just_pressed("analyze"):
				change_state(GAMEPLAY_STATE.EXPLORE)
				inventoryUi.visible = false
				reset_inventory_icon()

		GAMEPLAY_STATE.CURSOR:
			player.can_move = false
			if Input.is_action_just_pressed("interact") and !$Cursor.interactable and $Cursor.close_cooled:
				_toggle_panel(overlapping_panel_name)
				player.interactable = null
				change_state(GAMEPLAY_STATE.EXPLORE)

# ran after a dialog sequence to check if a new item was added and toggles the prompt on the gameplay ui
func check_for_new_item():
	if Inventory.new_item_recieved:
		AudioManager.play_sfx(preload("res://assets/sound/sfx/itempickup_sfx.ogg"))
		print('new item')
		Inventory.new_item_recieved = false
		inventoryButton.texture_normal = preload("res://assets/sprites/ui/Main_Gameplay_UI/invent_menu_button_new_item.png")

# only used in "point n click mode"
func _toggle_panel(panel_number:String) -> void:
	print(panel_number)
	if panel_number == "":
		print("returning")
		return
	var panelCover:Polygon2D = $PanelCovers.get_node(panel_number)
	var panelImg:Sprite2D = $JanePanels.get_node(panel_number)
	var cursorPosition:Marker2D = $CursorPositions.get_node(panel_number)
	$Cursor.position = cursorPosition.position
	$Cursor.visible = !$Cursor.visible
	panelImg.visible = !panelImg.visible
	$Cursor.can_move = !$Cursor.can_move
	panelCover.visible = !panelCover.visible 

func change_to_cursor():
	_toggle_panel(overlapping_panel_name)	
	change_state(GAMEPLAY_STATE.CURSOR)

func reset_inventory_icon():
	if collected_everything_check():
		next_page()
	inventoryButton.texture_normal = preload("res://assets/sprites/ui/Main_Gameplay_UI/invent_menu_button.png")

func change_state(new_state:GAMEPLAY_STATE):
	print_debug('new state: ', new_state)
	current_state = new_state
	if new_state == GAMEPLAY_STATE.CURSOR:
		$Cursor.double_input_prevention()


func next_page() -> void:
	AudioManager.play_sfx(preload("res://assets/sound/sfx/transition.ogg"))
	match page:
		PAGES.page1_2:
			%DialogueUI.hide()
			#get_tree().paused() = true
			%AnimationPlayer.play("fade")
			await %AnimationPlayer.animation_finished
			get_tree().change_scene_to_file("res://src/levels/2/level2-1-1.tscn")
		PAGES.page2_1_1:
			%DialogueManager.load_npc_dialogue(19, 20,jane_sprite , null)
			await %DialogueManager.dialogue_ended
			%DialogueUI.hide()
			#get_tree().paused() = true
			%AnimationPlayer.play("fade")
			await %AnimationPlayer.animation_finished
			get_tree().change_scene_to_file("res://src/levels/2/level2-1-2.tscn")
		PAGES.page2_1_2:
			%DialogueManager.load_npc_dialogue(21, 26,jane_sprite , null)
			await %DialogueManager.dialogue_ended
			%DialogueUI.hide()
			#get_tree().paused() = true
			%AnimationPlayer.play("fade")
			await %AnimationPlayer.animation_finished
			get_tree().change_scene_to_file("res://src/levels/2/level2-2.tscn")
		PAGES.page2_2:
			%DialogueUI.hide()
			#get_tree().paused() = true
			%AnimationPlayer.play("fade")
			await %AnimationPlayer.animation_finished
			get_tree().change_scene_to_file("res://src/levels/end.tscn")

func _solved_clues() -> void:	
	match page:
		PAGES.page1_2:
			%CopUnsolved.monitorable = false
			%CopSolved.monitorable = true
	pass

func _handle_dialouge_event(event_str):
	print(event_str)
	if event_str == "solved_page_puzzle":
		change_state(GAMEPLAY_STATE.EXPLORE)
		_solved_clues()	
	if event_str == "next_page":
		change_state(GAMEPLAY_STATE.EXPLORE)
		next_page()
	if event_str == "next_cop_dialouge":
			%Cop1.monitorable = false
			%Cop2.monitorable = true

func _unhandled_input(event: InputEvent) -> void:	
	#"fixes" issue with cursor and being stuck in diouge state?
	if event.is_action_pressed("stuck_in_dialouge"):
		if !$Cursor.visible:
			return
		player.in_dialouge = false
		change_state(GAMEPLAY_STATE.CURSOR)
		# if current_state == GAMEPLAY_STATE.DIALOG:
		# 	_toggle_panel(overlapping_panel_name)
		# 	player.interactable = null
		# 	player.in_dialouge = false
		# 	change_state(GAMEPLAY_STATE.EXPLORE)
