extends Node
class_name CardManager

# 信号
signal card_registered(card_id: String, card_data: Dictionary)
signal deck_loaded(deck_name: String)

# 卡牌注册表
var _cards: Dictionary = {}
var _deck_name: String
var _namespace: String

func _init(deck_name: String, namespace: String) -> void:
	_deck_name = deck_name
	_namespace = namespace

# 加载卡牌配置文件
func load_cards_from_file(file_path: String) -> void:
	var cards := CardLoader.load_cards_from_file(file_path)
	for card_data in cards:
		register_card(card_data)
	
	emit_signal("deck_loaded", _deck_name)

# 注册卡牌
func register_card(card_data: Dictionary) -> void:
	var card_id := _generate_card_id(card_data.name)
	if _cards.has(card_id):
		push_warning("卡牌已存在，将被覆盖：" + card_id)
	
	_cards[card_id] = card_data
	emit_signal("card_registered", card_id, card_data)

# 获取卡牌数据
func get_card_data(card_id: String) -> Dictionary:
	return _cards.get(card_id, {})

# 获取所有卡牌ID
func get_all_card_ids() -> Array:
	return _cards.keys()

# 创建卡牌实例
func create_card_instance(card_id: String) -> BaseCard:
	var card_data := get_card_data(card_id)
	if card_data.is_empty():
		push_error("找不到卡牌：" + card_id)
		return null
	
	# 根据效果类型确定卡牌类型
	var card_type := _determine_card_type(card_data)
	var target_type := _determine_target_type(card_data)
	
	# 创建卡牌实例
	return BaseCard.new({
		"name": card_data.name,
		"description": card_data.description,
		"type": card_type,
		"target_type": target_type,
		"effects": card_data.effects
	})

# 生成唯一的卡牌ID
func _generate_card_id(card_name: String) -> String:
	# 使用命名空间确保不同牌堆的卡牌ID不会冲突
	return _namespace + "." + card_name.to_lower().replace(" ", "_")

# 根据效果确定卡牌类型
func _determine_card_type(card_data: Dictionary) -> int:
	var effects: Array = card_data.get("effects", [])
	
	for effect in effects:
		match effect.get("type"):
			"damage":
				return CardConfig.CardType.ATTACK
			"defense":
				return CardConfig.CardType.DEFENSE
			"heal":
				return CardConfig.CardType.HEAL
			"status":
				return CardConfig.CardType.STATUS
	
	return CardConfig.CardType.UTILITY

# 根据效果确定目标类型
func _determine_target_type(card_data: Dictionary) -> int:
	var effects: Array = card_data.get("effects", [])
	var has_damage := false
	var has_status := false
	
	for effect in effects:
		match effect.get("type"):
			"damage":
				has_damage = true
			"status":
				has_status = true
	
	if has_damage or has_status:
		return CardConfig.TargetType.SINGLE
	
	return CardConfig.TargetType.NONE

# 创建一副新牌
func create_deck(card_counts: Dictionary = {}) -> Array:
	var deck: Array[BaseCard] = []
	
	if card_counts.is_empty():
		# 默认每张卡牌放入一张
		for card_id in get_all_card_ids():
			deck.append(create_card_instance(card_id))
	else:
		# 按指定数量放入卡牌
		for card_id in card_counts:
			var count: int = card_counts[card_id]
			for i in count:
				var card := create_card_instance(card_id)
				if card:
					deck.append(card)
	
	return deck 