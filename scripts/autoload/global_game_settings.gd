extends Node

var settings: Dictionary = {}

func _ready() -> void:
    load_settings()

func load_settings() -> void:
    var file = FileAccess.open("res://resources/game_config/game_settings.json", FileAccess.READ)
    if file:
        var json = JSON.new()
        var parse_result = json.parse(file.get_as_text())
        if parse_result == OK:
            settings = json.get_data()
        file.close()
    else:
        push_error("无法加载游戏配置文件") 