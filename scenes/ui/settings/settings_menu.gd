extends Control

# 节点引用
@onready var resolution_option = $MarginContainer/VBoxContainer/TabContainer/图形/VBoxContainer/Resolution/OptionButton
@onready var window_mode_option = $MarginContainer/VBoxContainer/TabContainer/图形/VBoxContainer/WindowMode/OptionButton
@onready var vsync_check = $MarginContainer/VBoxContainer/TabContainer/图形/VBoxContainer/VSync/CheckBox
@onready var aa_option = $MarginContainer/VBoxContainer/TabContainer/图形/VBoxContainer/AntiAliasing/OptionButton

@onready var master_volume_slider = $MarginContainer/VBoxContainer/TabContainer/音频/VBoxContainer/MasterVolume/HSlider
@onready var music_volume_slider = $MarginContainer/VBoxContainer/TabContainer/音频/VBoxContainer/MusicVolume/HSlider
@onready var sfx_volume_slider = $MarginContainer/VBoxContainer/TabContainer/音频/VBoxContainer/SFXVolume/HSlider

@onready var language_option = $MarginContainer/VBoxContainer/TabContainer/游戏/VBoxContainer/Language/OptionButton
@onready var card_speed_slider = $MarginContainer/VBoxContainer/TabContainer/游戏/VBoxContainer/CardSpeed/HSlider
@onready var auto_end_turn_check = $MarginContainer/VBoxContainer/TabContainer/游戏/VBoxContainer/AutoEndTurn/CheckBox
@onready var show_damage_check = $MarginContainer/VBoxContainer/TabContainer/游戏/VBoxContainer/ShowDamageNumbers/CheckBox

@onready var drag_threshold_slider = $MarginContainer/VBoxContainer/TabContainer/操作/VBoxContainer/DragThreshold/HSlider
@onready var double_click_slider = $MarginContainer/VBoxContainer/TabContainer/操作/VBoxContainer/DoubleClickSpeed/HSlider

@onready var reset_button = $MarginContainer/VBoxContainer/ButtonContainer/ResetButton
@onready var apply_button = $MarginContainer/VBoxContainer/ButtonContainer/ApplyButton
@onready var back_button = $MarginContainer/VBoxContainer/ButtonContainer/BackButton

# 分辨率选项
const RESOLUTIONS = [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

# 默认设置
const DEFAULT_SETTINGS = {
	"resolution": 0,
	"window_mode": 0,
	"vsync": true,
	"aa_mode": 2,
	"master_volume": 1.0,
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"language": 0,
	"card_speed": 1.0,
	"auto_end_turn": false,
	"show_damage": true,
	"drag_threshold": 10.0,
	"double_click_speed": 0.5
}

# 当前设置
var current_settings = DEFAULT_SETTINGS.duplicate()
var has_changes = false

func _ready():
	# 连接信号
	_connect_signals()
	
	# 加载设置
	_load_settings()
	
	# 更新UI
	_update_ui()

func _connect_signals():
	resolution_option.item_selected.connect(_on_resolution_changed)
	window_mode_option.item_selected.connect(_on_window_mode_changed)
	vsync_check.toggled.connect(_on_vsync_changed)
	aa_option.item_selected.connect(_on_aa_changed)
	
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	
	language_option.item_selected.connect(_on_language_changed)
	card_speed_slider.value_changed.connect(_on_card_speed_changed)
	auto_end_turn_check.toggled.connect(_on_auto_end_turn_changed)
	show_damage_check.toggled.connect(_on_show_damage_changed)
	
	drag_threshold_slider.value_changed.connect(_on_drag_threshold_changed)
	double_click_slider.value_changed.connect(_on_double_click_speed_changed)
	
	reset_button.pressed.connect(_on_reset_pressed)
	apply_button.pressed.connect(_on_apply_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _load_settings():
	# 从GameManager加载设置
	var config = GameManager.config
	current_settings = DEFAULT_SETTINGS.duplicate()
	
	# 更新当前设置
	if config.has("resolution"):
		current_settings.resolution = config.resolution
	if config.has("window_mode"):
		current_settings.window_mode = config.window_mode
	if config.has("vsync"):
		current_settings.vsync = config.vsync
	if config.has("aa_mode"):
		current_settings.aa_mode = config.aa_mode
	if config.has("master_volume"):
		current_settings.master_volume = config.master_volume
	if config.has("music_volume"):
		current_settings.music_volume = config.music_volume
	if config.has("sfx_volume"):
		current_settings.sfx_volume = config.sfx_volume
	if config.has("language"):
		current_settings.language = config.language
	if config.has("card_speed"):
		current_settings.card_speed = config.card_speed
	if config.has("auto_end_turn"):
		current_settings.auto_end_turn = config.auto_end_turn
	if config.has("show_damage"):
		current_settings.show_damage = config.show_damage
	if config.has("drag_threshold"):
		current_settings.drag_threshold = config.drag_threshold
	if config.has("double_click_speed"):
		current_settings.double_click_speed = config.double_click_speed

func _update_ui():
	resolution_option.selected = current_settings.resolution
	window_mode_option.selected = current_settings.window_mode
	vsync_check.button_pressed = current_settings.vsync
	aa_option.selected = current_settings.aa_mode
	
	master_volume_slider.value = current_settings.master_volume
	music_volume_slider.value = current_settings.music_volume
	sfx_volume_slider.value = current_settings.sfx_volume
	
	language_option.selected = current_settings.language
	card_speed_slider.value = current_settings.card_speed
	auto_end_turn_check.button_pressed = current_settings.auto_end_turn
	show_damage_check.button_pressed = current_settings.show_damage
	
	drag_threshold_slider.value = current_settings.drag_threshold
	double_click_slider.value = current_settings.double_click_speed
	
	apply_button.disabled = !has_changes

func _mark_changes():
	has_changes = true
	apply_button.disabled = false

func _on_resolution_changed(index: int):
	current_settings.resolution = index
	_mark_changes()

func _on_window_mode_changed(index: int):
	current_settings.window_mode = index
	_mark_changes()

func _on_vsync_changed(enabled: bool):
	current_settings.vsync = enabled
	_mark_changes()

func _on_aa_changed(index: int):
	current_settings.aa_mode = index
	_mark_changes()

func _on_master_volume_changed(value: float):
	current_settings.master_volume = value
	_mark_changes()

func _on_music_volume_changed(value: float):
	current_settings.music_volume = value
	_mark_changes()

func _on_sfx_volume_changed(value: float):
	current_settings.sfx_volume = value
	_mark_changes()

func _on_language_changed(index: int):
	current_settings.language = index
	_mark_changes()

func _on_card_speed_changed(value: float):
	current_settings.card_speed = value
	_mark_changes()

func _on_auto_end_turn_changed(enabled: bool):
	current_settings.auto_end_turn = enabled
	_mark_changes()

func _on_show_damage_changed(enabled: bool):
	current_settings.show_damage = enabled
	_mark_changes()

func _on_drag_threshold_changed(value: float):
	current_settings.drag_threshold = value
	_mark_changes()

func _on_double_click_speed_changed(value: float):
	current_settings.double_click_speed = value
	_mark_changes()

func _on_reset_pressed():
	current_settings = DEFAULT_SETTINGS.duplicate()
	_update_ui()
	_mark_changes()

func _on_apply_pressed():
	# 应用分辨率
	if current_settings.resolution >= 0 and current_settings.resolution < RESOLUTIONS.size():
		var res = RESOLUTIONS[current_settings.resolution]
		get_window().size = res
	
	# 应用窗口模式
	match current_settings.window_mode:
		0: # 窗口
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # 无边框窗口
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2: # 全屏
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# 应用垂直同步
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if current_settings.vsync else DisplayServer.VSYNC_DISABLED
	)
	
	# 应用抗锯齿
	var viewport_rid = get_viewport().get_viewport_rid()
	match current_settings.aa_mode:
		0: # 关闭
			RenderingServer.viewport_set_screen_space_aa(viewport_rid, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
		1: # FXAA
			RenderingServer.viewport_set_screen_space_aa(viewport_rid, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
		2, 3: # MSAA
			# 由于GLES3不支持2D MSAA，我们使用屏幕空间抗锯齿代替
			RenderingServer.viewport_set_screen_space_aa(viewport_rid, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
			# 启用去带宽
			RenderingServer.viewport_set_use_debanding(viewport_rid, true)
	
	# 更新GameManager配置
	GameManager.config.merge(current_settings)
	GameManager.save_config()
	
	has_changes = false
	apply_button.disabled = true

func _on_back_pressed():
	if has_changes:
		# TODO: 显示确认对话框
		pass
	queue_free() 