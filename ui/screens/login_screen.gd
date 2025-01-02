extends Control

@onready var username_input: LineEdit = $PanelContainer/VBoxContainer/UsernameInput
@onready var password_input: LineEdit = $PanelContainer/VBoxContainer/PasswordInput
@onready var login_button: Button = $PanelContainer/VBoxContainer/LoginButton
@onready var register_button: Button = $PanelContainer/VBoxContainer/RegisterButton
@onready var error_label: Label = $PanelContainer/VBoxContainer/ErrorLabel

# 信号
signal login_successful
signal register_requested

func _ready() -> void:
	# 连接信号
	login_button.pressed.connect(_on_login_button_pressed)
	register_button.pressed.connect(_on_register_button_pressed)
	
	# 设置输入框
	username_input.placeholder_text = "用户名"
	password_input.placeholder_text = "密码"
	password_input.secret = true
	
	# 隐藏错误信息
	error_label.hide()
	
	# 设置面板位置
	_center_panel()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		_center_panel()

func _center_panel() -> void:
	var panel = $PanelContainer
	panel.position = get_viewport_rect().size / 2 - panel.size / 2

func _on_login_button_pressed() -> void:
	var username = username_input.text.strip_edges()
	var password = password_input.text
	
	# 验证输入
	if username.is_empty() or password.is_empty():
		_show_error("请输入用户名和密码")
		return
	
	# 这里应该调用实际的登录逻辑
	# 临时模拟登录成功
	_login_success(username)

func _on_register_button_pressed() -> void:
	emit_signal("register_requested")

func _show_error(message: String) -> void:
	error_label.text = message
	error_label.show()
	
	# 创建抖动动画
	var tween = create_tween()
	var original_pos = error_label.position
	var shake_strength = 5.0
	
	for i in range(5):
		tween.tween_property(error_label, "position:x", 
			original_pos.x - shake_strength, 0.1)
		tween.tween_property(error_label, "position:x", 
			original_pos.x + shake_strength, 0.1)
	
	tween.tween_property(error_label, "position:x", original_pos.x, 0.1)
	
	# 3秒后隐藏错误信息
	await get_tree().create_timer(3.0).timeout
	error_label.hide()

func _login_success(username: String) -> void:
	# 保存用户信息
	var game_manager = get_node("/root/GameManager")
	game_manager.player_data["name"] = username
	game_manager.save_player_data()
	
	# 发送登录成功信号
	emit_signal("login_successful")
	
	# 切换到主菜单场景
	get_parent().get_parent().load_scene("res://scenes/menu/main_menu.tscn") 