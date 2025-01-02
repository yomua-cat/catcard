extends Panel
class_name CardDetailsPanel

@onready var card_name_label: Label = $VBoxContainer/CardNameLabel
@onready var card_cost_label: Label = $VBoxContainer/CardCostLabel
@onready var card_description_label: Label = $VBoxContainer/CardDescriptionLabel
@onready var card_type_label: Label = $VBoxContainer/CardTypeLabel
@onready var card_rarity_label: Label = $VBoxContainer/CardRarityLabel

# 信号
signal close_requested

func _ready() -> void:
	# 连接关闭按钮信号
	$CloseButton.pressed.connect(_on_close_button_pressed)
	
	# 设置初始状态为隐藏
	hide()

# 更新卡牌信息显示
func update_card_info(card_data: Dictionary) -> void:
	card_name_label.text = card_data.get("name", "未知卡牌")
	card_cost_label.text = "费用：" + str(card_data.get("cost", 0))
	card_description_label.text = card_data.get("description", "无描述")
	card_type_label.text = "类型：" + card_data.get("type", "未知")
	card_rarity_label.text = "稀有度：" + card_data.get("rarity", "普通")

# 显示面板
func show_panel(card_data: Dictionary) -> void:
	update_card_info(card_data)
	show()
	
	# 添加显示动画
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)

# 隐藏面板
func hide_panel() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)
	tween.tween_callback(hide)

func _on_close_button_pressed() -> void:
	hide_panel()
	emit_signal("close_requested")

# 响应输入事件
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		hide_panel()
		emit_signal("close_requested")
		get_viewport().set_input_as_handled() 