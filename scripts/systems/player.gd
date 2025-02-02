extends Node
class_name Player

signal health_changed(new_health: float, old_health: float)
signal defense_changed(new_defense: float, old_defense: float)
signal card_played(card: BaseCard)
signal card_drawn(card: BaseCard)
signal card_discarded(card: BaseCard)
signal status_effect_added(effect: StatusEffect)
signal status_effect_removed(effect: StatusEffect)

# 玩家属性
var player_name: String
var health: float = CardConfig.BASE_HP
var max_health: float = CardConfig.BASE_HP
var defense: float = CardConfig.BASE_DEFENSE
var fixed_defense: float = 0.0

# 手牌相关
var hand: Array[BaseCard] = []
var hand_size_limit: int = CardConfig.BASE_HAND_SIZE

# 状态效果
var status_effects: Array[StatusEffect] = []

# 回合状态
var is_active: bool = false
var can_play_cards: bool = true
var can_be_targeted: bool = true

func _init(name: String = "") -> void:
	player_name = name

# 生命值相关
func modify_health(amount: float) -> void:
	var old_health = health
	health = clamp(health + amount, 0, max_health)
	emit_signal("health_changed", health, old_health)

func modify_max_health(amount: float) -> void:
	max_health = max(0.5, max_health + amount)
	health = min(health, max_health)

# 防御值相关
func modify_defense(amount: float) -> void:
	var old_defense = defense
	defense = max(0, defense + amount)
	emit_signal("defense_changed", defense, old_defense)

func modify_fixed_defense(amount: float) -> void:
	fixed_defense = max(0, fixed_defense + amount)

# 手牌操作
func draw_card(card: BaseCard) -> void:
	if hand.size() < hand_size_limit:
		hand.append(card)
		card.owner = self
		emit_signal("card_drawn", card)

func discard_card(card: BaseCard) -> void:
	hand.erase(card)
	card.discard()
	emit_signal("card_discarded", card)

func play_card(card: BaseCard, targets: Array) -> void:
	if can_play_card(card):
		hand.erase(card)
		card.play(targets)
		emit_signal("card_played", card)

func can_play_card(card: BaseCard) -> bool:
	return can_play_cards

# 状态效果
func add_status_effect(effect: StatusEffect) -> void:
	status_effects.append(effect)
	effect.owner = self
	emit_signal("status_effect_added", effect)

func remove_status_effect(effect: StatusEffect) -> void:
	status_effects.erase(effect)
	emit_signal("status_effect_removed", effect)

# 回合管理
func start_turn() -> void:
	is_active = true
	_process_status_effects_start()

func end_turn() -> void:
	is_active = false
	defense = fixed_defense  # 回合结束时，非固定防御值清零
	_process_status_effects_end()

# 处理状态效果
func _process_status_effects_start() -> void:
	for effect in status_effects:
		effect.on_turn_start()

func _process_status_effects_end() -> void:
	for effect in status_effects:
		effect.on_turn_end()

# 伤害计算
func take_damage(amount: float) -> float:
	var actual_damage = amount
	if defense > 0 or fixed_defense > 0:
		var total_defense = defense + fixed_defense
		actual_damage = max(0, amount - total_defense)
		modify_defense(-min(defense, amount))
	
	if actual_damage > 0:
		modify_health(-actual_damage)
	
	return actual_damage 