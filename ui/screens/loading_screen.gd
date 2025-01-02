extends Control

@onready var progress_bar: ProgressBar = $CenterContainer/VBoxContainer/ProgressBar
@onready var loading_label: Label = $CenterContainer/VBoxContainer/LoadingLabel
@onready var tips_label: Label = $CenterContainer/VBoxContainer/TipsLabel

var tips := [
	"提示：卡牌可以通过拖拽来使用",
	"提示：右键点击卡牌可以查看详细信息",
	"提示：每回合开始时会自动抽取卡牌",
	"提示：合理搭配卡组可以提高胜率",
	"提示：注意关注卡牌之间的配合",
]

func _ready() -> void:
	# 初始化进度条
	progress_bar.value = 0
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	
	# 随机显示提示
	_show_random_tip()

# 更新加载进度
func update_progress(progress: float) -> void:
	# 创建进度条动画
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", progress * 100, 0.2)
	
	# 更新加载文本
	loading_label.text = "加载中... %d%%" % [progress * 100]
	
	# 在进度变化时随机更新提示
	if randf() < 0.3: # 30%的概率更新提示
		_show_random_tip()

# 显示随机提示
func _show_random_tip() -> void:
	tips_label.text = tips[randi() % tips.size()]
	
	# 创建淡入淡出动画
	var tween = create_tween()
	tween.tween_property(tips_label, "modulate:a", 0.0, 0.5)
	tween.tween_property(tips_label, "modulate:a", 1.0, 0.5) 