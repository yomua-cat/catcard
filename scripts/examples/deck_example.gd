extends Node

# 创建不同的卡牌管理器
var basic_deck_manager := CardManager.new("基础牌组", "basic")
var special_deck_manager := CardManager.new("特殊牌组", "special")

func _ready() -> void:
	# 加载不同的卡牌配置
	basic_deck_manager.load_cards_from_file("res://resources/cards/basic_deck.txt")
	special_deck_manager.load_cards_from_file("res://resources/cards/special_deck.txt")
	
	# 创建带有指定卡牌数量的牌组
	var deck_config := {
		"basic.attack": 3,        # 3张攻击牌
		"basic.defense": 2,       # 2张防御牌
		"basic.heal": 2,          # 2张治疗牌
		"special.fireball": 1     # 1张火球牌
	}
	
	var deck := basic_deck_manager.create_deck(deck_config)
	
	# 输出牌组信息
	print("牌组包含 %d 张卡牌：" % deck.size())
	for card in deck:
		print("- %s: %s" % [card.card_name, card.description])

# 示例：如何处理卡牌注册事件
func _on_card_registered(card_id: String, card_data: Dictionary) -> void:
	print("注册新卡牌：%s (%s)" % [card_data.name, card_id])

# 示例：如何处理牌组加载完成事件
func _on_deck_loaded(deck_name: String) -> void:
	print("牌组加载完成：%s" % deck_name) 