extends Node

# 游戏状态枚举
enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

# 当前游戏状态
var current_state: GameState = GameState.MENU

# 游戏配置
var config := {
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"fullscreen": false,
	"vsync": true
}

func _ready():
	# 加载配置
	_load_config()
	
	# 设置初始状态
	set_game_state(GameState.MENU)

func set_game_state(new_state: GameState):
	current_state = new_state
	match current_state:
		GameState.MENU:
			get_tree().paused = false
		GameState.PLAYING:
			get_tree().paused = false
		GameState.PAUSED:
			get_tree().paused = true
		GameState.GAME_OVER:
			get_tree().paused = true

func _load_config():
	if FileAccess.file_exists("user://config.save"):
		var file = FileAccess.open("user://config.save", FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		if json:
			config = json

func save_config():
	var file = FileAccess.open("user://config.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(config))

func toggle_fullscreen():
	config.fullscreen = !config.fullscreen
	if config.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_config()

func set_vsync(enabled: bool):
	config.vsync = enabled
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if enabled else DisplayServer.VSYNC_DISABLED)
	save_config()

func set_music_volume(volume: float):
	config.music_volume = volume
	# TODO: 实现音乐音量调节
	save_config()

func set_sfx_volume(volume: float):
	config.sfx_volume = volume
	# TODO: 实现音效音量调节
	save_config() 