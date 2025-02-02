extends Control

@onready var start_button = $ButtonContainer/StartButton
@onready var deck_button = $ButtonContainer/DeckButton
@onready var settings_button = $ButtonContainer/SettingsButton
@onready var quit_button = $ButtonContainer/QuitButton
@onready var animation_player = $AnimationPlayer

# 按钮悬停动画
const HOVER_SCALE = Vector2(1.1, 1.1)
const NORMAL_SCALE = Vector2(1.0, 1.0)
const HOVER_DURATION = 0.2

func _ready():
	# 连接信号
	start_button.pressed.connect(_on_start_pressed)
	deck_button.pressed.connect(_on_deck_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# 添加按钮悬停效果
	for button in $ButtonContainer.get_children():
		if button is Button:
			button.mouse_entered.connect(_on_button_hover.bind(button))
			button.mouse_exited.connect(_on_button_normal.bind(button))
	
	# 播放进入动画
	animation_player.play("menu_fade")

func _on_start_pressed():
	# 创建过渡动画
	var tween = create_tween()
	tween.tween_property($MainContainer, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(_start_game)

func _on_deck_pressed():
	# TODO: 实现卡组管理界面切换
	pass

func _on_settings_pressed():
	# TODO: 实现设置界面切换
	pass

func _on_quit_pressed():
	# 创建退出动画
	var tween = create_tween()
	tween.tween_property($MainContainer, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(get_tree().quit)

func _start_game():
	# TODO: 切换到游戏场景
	pass

func _on_button_hover(button: Button):
	# 创建悬停动画
	var tween = create_tween()
	tween.tween_property(button, "scale", HOVER_SCALE, HOVER_DURATION).set_trans(Tween.TRANS_QUAD)
	
	# 添加颜色变化
	tween.parallel().tween_property(button, "modulate", Color(1.2, 1.2, 1.2), HOVER_DURATION)

func _on_button_normal(button: Button):
	# 创建恢复动画
	var tween = create_tween()
	tween.tween_property(button, "scale", NORMAL_SCALE, HOVER_DURATION).set_trans(Tween.TRANS_QUAD)
	
	# 恢复颜色
	tween.parallel().tween_property(button, "modulate", Color.WHITE, HOVER_DURATION) 