extends Control

# 节点引用
@onready var hp_label = $TopBar/PlayerStats/HP
@onready var energy_label = $TopBar/PlayerStats/Energy
@onready var turn_label = $TopBar/TurnInfo
@onready var draw_pile_label = $TopBar/DeckInfo/DrawPile
@onready var discard_pile_label = $TopBar/DeckInfo/DiscardPile
@onready var hand_container = $HandContainer
@onready var end_turn_button = $EndTurnButton
@onready var animation_player = $AnimationPlayer
@onready var status_effects = $StatusEffects
@onready var energy_display = $EnergyDisplay

# 卡牌动画常量
const CARD_SPACING = 140
const CARD_HOVER_HEIGHT = -30
const CARD_DRAW_DURATION = 0.3
const CARD_HOVER_DURATION = 0.2

# 游戏状态
var current_turn := 1
var current_energy := 3
var max_energy := 3
var current_hp := 10
var max_hp := 10
var draw_pile_count := 30
var discard_pile_count := 0
var hand_cards := []

func _ready():
	# 连接信号
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	
	# 初始化UI
	_update_labels()
	
	# 测试添加一些卡牌
	_add_test_cards()

func _update_labels():
	hp_label.text = "生命值: %d/%d" % [current_hp, max_hp]
	energy_label.text = "能量: %d/%d" % [current_energy, max_energy]
	turn_label.text = "回合 %d" % current_turn
	draw_pile_label.text = "抽牌堆: %d" % draw_pile_count
	discard_pile_label.text = "弃牌堆: %d" % discard_pile_count
	energy_display.text = str(current_energy)

func _add_test_cards():
	# 添加测试卡牌
	for i in range(5):
		var card = preload("res://scenes/cards/card.tscn").instantiate()
		hand_container.add_child(card)
		hand_cards.append(card)
		
		# 设置卡牌位置和动画
		card.position.x = i * CARD_SPACING
		_play_card_draw_animation(card)
		
		# 连接卡牌信号
		card.mouse_entered.connect(_on_card_hover.bind(card))
		card.mouse_exited.connect(_on_card_normal.bind(card))
		card.gui_input.connect(_on_card_input.bind(card))

func _play_card_draw_animation(card: Node):
	# 创建抽牌动画
	var tween = create_tween()
	card.scale = Vector2.ZERO
	tween.tween_property(card, "scale", Vector2.ONE, CARD_DRAW_DURATION).set_trans(Tween.TRANS_BACK)

func _on_card_hover(card: Node):
	# 创建卡牌悬停动画
	var tween = create_tween()
	tween.tween_property(card, "position:y", CARD_HOVER_HEIGHT, CARD_HOVER_DURATION).set_trans(Tween.TRANS_QUAD)

func _on_card_normal(card: Node):
	# 创建卡牌恢复动画
	var tween = create_tween()
	tween.tween_property(card, "position:y", 0, CARD_HOVER_DURATION).set_trans(Tween.TRANS_QUAD)

func _on_card_input(event: InputEvent, card: Node):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_energy > 0:
			_play_card(card)

func _play_card(card: Node):
	# 创建使用卡牌动画
	var tween = create_tween()
	tween.tween_property(card, "scale", Vector2.ZERO, CARD_DRAW_DURATION)
	tween.tween_callback(func(): 
		hand_cards.erase(card)
		card.queue_free()
		current_energy -= 1
		discard_pile_count += 1
		_update_labels()
		_rearrange_hand()
	)

func _rearrange_hand():
	# 重新排列手牌
	for i in range(hand_cards.size()):
		var card = hand_cards[i]
		var tween = create_tween()
		tween.tween_property(card, "position:x", i * CARD_SPACING, CARD_HOVER_DURATION)

func _on_end_turn_pressed():
	# 创建回合结束动画
	var tween = create_tween()
	tween.tween_property($HandContainer, "modulate", Color.TRANSPARENT, 0.3)
	tween.tween_callback(func():
		# 清理当前手牌
		for card in hand_cards:
			card.queue_free()
		hand_cards.clear()
		
		# 更新游戏状态
		current_turn += 1
		current_energy = max_energy
		discard_pile_count += hand_cards.size()
		
		# 重置UI
		$HandContainer.modulate = Color.WHITE
		_update_labels()
		
		# 抽新的手牌
		_add_test_cards()
	)

func add_status_effect(effect_name: String, duration: int):
	# 添加状态效果
	var effect_label = Label.new()
	effect_label.text = "%s(%d)" % [effect_name, duration]
	status_effects.add_child(effect_label)
	
	# 创建添加动画
	effect_label.modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(effect_label, "modulate", Color.WHITE, 0.3)

func remove_status_effect(effect_name: String):
	# 移除状态效果
	for effect in status_effects.get_children():
		if effect.text.begins_with(effect_name):
			var tween = create_tween()
			tween.tween_property(effect, "modulate", Color.TRANSPARENT, 0.3)
			tween.tween_callback(effect.queue_free) 