extends Node3D

# 场景引用
@onready var logo_screen: Control = $UI/LogoScreen
@onready var login_screen: Control = $UI/LoginScreen
@onready var loading_screen: Control = $UI/LoadingScreen
@onready var background_environment: WorldEnvironment = $WorldEnvironment
@onready var main_camera: Camera3D = $MainCamera

# 场景状态
var current_screen: Control = null
const FADE_DURATION := 1.0

# 加载状态常量
const LOAD_STATUS_INVALID_RESOURCE = 0
const LOAD_STATUS_RESOURCE_ERROR = 1
const LOAD_STATUS_LOADING = 2
const LOAD_STATUS_LOADED = 3

func _ready() -> void:
	# 设置初始状态
	get_tree().paused = false
	
	# 隐藏所有UI屏幕
	for screen in $UI.get_children():
		if screen is Control:
			screen.hide()
			
			screen.modulate.a = 0
	
	# 开始显示Logo
	show_logo()

# 显示Logo
func show_logo() -> void:
	var logo_duration := 2.0
	
	# 显示Logo
	current_screen = logo_screen
	logo_screen.show()
	
	# 创建渐入动画
	var tween = create_tween()
	tween.tween_property(logo_screen, "modulate:a", 1.0, FADE_DURATION)
	
	# 等待显示时间后渐出
	tween.tween_interval(logo_duration)
	tween.tween_property(logo_screen, "modulate:a", 0.0, FADE_DURATION)
	
	# Logo结束后显示登录界面
	tween.tween_callback(func():
		logo_screen.hide()
		show_login_screen()
	)

# 显示登录界面
func show_login_screen() -> void:
	current_screen = login_screen
	login_screen.show()
	
	# 创建渐入动画
	var tween = create_tween()
	tween.tween_property(login_screen, "modulate:a", 1.0, FADE_DURATION)

# 显示加载界面
func show_loading_screen() -> void:
	if current_screen:
		# 淡出当前界面
		var fade_out_tween = create_tween()
		fade_out_tween.tween_property(current_screen, "modulate:a", 0.0, FADE_DURATION)
		fade_out_tween.tween_callback(current_screen.hide)
	
	current_screen = loading_screen
	loading_screen.show()
	
	# 创建渐入动画
	var tween = create_tween()
	tween.tween_property(loading_screen, "modulate:a", 1.0, FADE_DURATION)

# 加载场景
func load_scene(scene_path: String) -> void:
	show_loading_screen()
	
	# 创建加载线程
	var _loader = ResourceLoader.load_threaded_request(scene_path)
	
	# 等待加载完成
	while true:
		var status = ResourceLoader.load_threaded_get_status(scene_path)
		match status:
			LOAD_STATUS_LOADED:
				var new_scene = ResourceLoader.load_threaded_get(scene_path)
				get_tree().change_scene_to_packed(new_scene)
				break
			LOAD_STATUS_LOADING:
				# 更新加载进度
				var progress = []
				ResourceLoader.load_threaded_get_status(scene_path, progress)
				loading_screen.update_progress(progress[0])
				await get_tree().create_timer(0.1).timeout
			_:
				print("加载错误:", status)
				break 