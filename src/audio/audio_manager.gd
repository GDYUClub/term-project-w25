extends Node

var audio_bus_name := "Master"

#@onready var _bus := AudioServer.get_bus_index(audio_bus_name)
var _bus := AudioServer.get_bus_index(audio_bus_name)
var bgm_player :AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_players :Array[AudioStreamPlayer]
var SFX_PLAYER_COUNT:int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(bgm_player)
	for i in range(SFX_PLAYER_COUNT):
		var sfx_player :=AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_players.append(sfx_player)

	bgm_player.process_mode = AudioStreamPlayer.PROCESS_MODE_ALWAYS
	set_volume(1)

func play_music(music:AudioStream) -> void:
	if bgm_player.stream == music:
		return

	bgm_player.stream = music
	if music.resource_path == "res://assets/sound/bgm/house-theme.ogg":
		bgm_player.volume_db = linear_to_db(3)
	else:
		bgm_player.volume_db = linear_to_db(1)
	bgm_player.play()

func pause_music() -> void:
	bgm_player.stop()

func play_sfx(sfx:AudioStream) -> void:
	for sfx_player:AudioStreamPlayer in sfx_players:
		if !sfx_player.playing:
			sfx_player.stream = sfx
			sfx_player.play()
			break

func set_volume(value:float) -> void:
	AudioServer.set_bus_volume_db(_bus,linear_to_db(value))

func stop_all() -> void:
	for sfx_player:AudioStreamPlayer in sfx_players:
		sfx_player.stop()
	
	
