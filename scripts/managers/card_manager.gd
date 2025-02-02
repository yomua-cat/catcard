extends Node

# 卡牌数据
var card_data := {}
var player_deck := []
var draw_pile := []
var discard_pile := []
var hand := []

# 卡牌配置
const MAX_HAND_SIZE := 10
const CARDS_PER_TURN := 5

func _ready():
	# 加载卡牌数据
	_load_card_data()
	
	# 初始化玩家卡组
	_init_player_deck()

func _load_card_data():
	if FileAccess.file_exists("res://resources/cards/basic_deck.txt"):
		var file = FileAccess.open("res://resources/cards/basic_deck.txt", FileAccess.READ)
		var content = file.get_as_text()
		
		for line in content.split("\n"):
			if line.begins_with("#") or line.strip_edges() == "":
				continue
				
			var parts = line.split(":")
			if parts.size() == 2:
				var card_name = parts[0].strip_edges()
				var card_effects = parts[1].strip_edges()
				card_data[card_name] = card_effects

func _init_player_deck():
	# 清空现有卡组
	player_deck.clear()
	draw_pile.clear()
	discard_pile.clear()
	hand.clear()
	
	# 添加基础卡牌
	for card_name in card_data.keys():
		# 每种卡牌添加3张
		for i in range(3):
			player_deck.append(card_name)
	
	# 洗牌
	shuffle_deck()

func shuffle_deck():
	# 将弃牌堆放入抽牌堆
	draw_pile.append_array(discard_pile)
	discard_pile.clear()
	
	# 随机打乱
	draw_pile.shuffle()

func draw_card() -> String:
	if draw_pile.is_empty():
		if not discard_pile.is_empty():
			shuffle_deck()
		else:
			return ""
	
	if hand.size() >= MAX_HAND_SIZE:
		return ""
	
	var card = draw_pile.pop_back()
	hand.append(card)
	return card

func draw_cards(amount: int) -> Array:
	var drawn_cards := []
	for i in range(amount):
		var card = draw_card()
		if card != "":
			drawn_cards.append(card)
	return drawn_cards

func discard_card(card_index: int):
	if card_index >= 0 and card_index < hand.size():
		var card = hand[card_index]
		hand.remove_at(card_index)
		discard_pile.append(card)

func discard_hand():
	for card in hand:
		discard_pile.append(card)
	hand.clear()

func get_card_effects(card_name: String) -> String:
	return card_data.get(card_name, "") 