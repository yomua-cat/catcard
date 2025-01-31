extends Node

# 场景引用
@onready var ui_layer: CanvasLayer = $UILayer
@onready var main_menu: Control = $UILayer/MainMenu
@onready var loading_screen: Control = $UILayer/LoadingScreen

func _ready() -> void:
    # 初始化UI
    setup_ui()
    # 显示主菜单
    show_main_menu()

func setup_ui() -> void:
    # 设置UI比例
    get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
    get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
    
    # 初始化加载界面为隐藏状态
    if loading_screen:
        loading_screen.hide()

func show_main_menu() -> void:
    if main_menu:
        main_menu.show()

# 开始单人游戏
func _on_single_player_pressed() -> void:
    print("开始单人游戏")
    # TODO: 实现单人游戏逻辑

# 开始多人游戏
func _on_multiplayer_pressed() -> void:
    print("开始多人游戏")
    # TODO: 实现多人游戏逻辑

# 打开设置
func _on_settings_pressed() -> void:
    print("打开设置")
    # TODO: 实现设置界面

# 退出游戏
func _on_quit_pressed() -> void:
    get_tree().quit() 