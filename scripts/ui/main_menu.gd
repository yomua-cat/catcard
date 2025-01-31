extends Control

# 按钮引用
@onready var single_player_btn: Button = $CenterContainer/VBoxContainer/SinglePlayerBtn
@onready var multiplayer_btn: Button = $CenterContainer/VBoxContainer/MultiplayerBtn
@onready var settings_btn: Button = $CenterContainer/VBoxContainer/SettingsBtn
@onready var quit_btn: Button = $CenterContainer/VBoxContainer/QuitBtn

func _ready() -> void:
    # 连接按钮信号
    single_player_btn.pressed.connect(_on_single_player_pressed)
    multiplayer_btn.pressed.connect(_on_multiplayer_pressed)
    settings_btn.pressed.connect(_on_settings_pressed)
    quit_btn.pressed.connect(_on_quit_pressed)
    
    # 设置按钮样式
    setup_buttons()

func setup_buttons() -> void:
    var buttons = [single_player_btn, multiplayer_btn, settings_btn, quit_btn]
    for button in buttons:
        if button:
            button.custom_minimum_size = Vector2(200, 50)
            button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

# 信号处理函数
func _on_single_player_pressed() -> void:
    get_parent().get_parent()._on_single_player_pressed()

func _on_multiplayer_pressed() -> void:
    get_parent().get_parent()._on_multiplayer_pressed()

func _on_settings_pressed() -> void:
    get_parent().get_parent()._on_settings_pressed()

func _on_quit_pressed() -> void:
    get_parent().get_parent()._on_quit_pressed() 