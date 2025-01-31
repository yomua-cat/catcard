extends Control

@onready var progress_bar: ProgressBar = $CenterContainer/VBoxContainer/ProgressBar
@onready var status_label: Label = $CenterContainer/VBoxContainer/StatusLabel

func _ready() -> void:
    # 初始化进度条
    if progress_bar:
        progress_bar.value = 0
    
    # 初始化状态文本
    if status_label:
        status_label.text = "准备中..."

# 更新加载进度
func update_progress(value: float, status: String = "") -> void:
    if progress_bar:
        progress_bar.value = value
    
    if status_label and status != "":
        status_label.text = status

# 重置加载界面
func reset() -> void:
    if progress_bar:
        progress_bar.value = 0
    
    if status_label:
        status_label.text = "准备中..." 