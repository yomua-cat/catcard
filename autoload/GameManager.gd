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

# 玩家数据
var player_data := {
	"name": "",
	"deck": [],
	"collection": [],
	"experience": 0,
	"level": 1
}

# 游戏设置
var settings := {
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"language": "zh"
}

# 信号
signal game_state_changed(new_state: GameState)
signal player_data_updated

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_settings()

# 改变游戏状态
func change_game_state(new_state: GameState) -> void:
	current_state = new_state
	emit_signal("game_state_changed", new_state)

# 保存游戏设置
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("settings", "music_volume", settings.music_volume)
	config.set_value("settings", "sfx_volume", settings.sfx_volume)
	config.set_value("settings", "language", settings.language)
	config.save("user://settings.cfg")

# 加载游戏设置
func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		settings.music_volume = config.get_value("settings", "music_volume", 1.0)
		settings.sfx_volume = config.get_value("settings", "sfx_volume", 1.0)
		settings.language = config.get_value("settings", "language", "zh")

# 保存玩家数据
func save_player_data() -> void:
	var save_game = FileAccess.open("user://player_data.save", FileAccess.WRITE)
	save_game.store_var(player_data)
	emit_signal("player_data_updated")

# 加载玩家数据
func load_player_data() -> void:
	if FileAccess.file_exists("user://player_data.save"):
		var save_game = FileAccess.open("user://player_data.save", FileAccess.READ)
		player_data = save_game.get_var()
		emit_signal("player_data_updated") 