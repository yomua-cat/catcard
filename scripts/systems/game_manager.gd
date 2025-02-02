extends Node
class_name GameManager

signal turn_started(player: Player)
signal turn_ended(player: Player)
signal game_started
signal game_ended(winner: Player)

# 游戏状态
var players: Array[Player] = []
var current_player_index: int = -1
var current_player: Player = null
var turn_number: int = 0
var game_ended: bool = false

# 卡牌管理
var deck: Array[BaseCard] = []
var discard_pile: Array[BaseCard] = []

func _init() -> void:
	pass

# 游戏流程管理
func start_game() -> void:
	if players.size() < 2:
		push_error("需要至少2名玩家才能开始游戏")
		return
	
	game_ended = false
	turn_number = 0
	_shuffle_deck()
	_deal_initial_cards()
	
	# 随机选择起始玩家
	current_player_index = randi() % players.size()
	current_player = players[current_player_index]
	
	emit_signal("game_started")
	start_turn()

func end_game(winner: Player) -> void:
	game_ended = true
	emit_signal("game_ended", winner)

# 回合管理
func start_turn() -> void:
	if game_ended:
		return
	
	turn_number += 1
	current_player.start_turn()
	
	# 抽牌阶段
	for i in CardConfig.BASE_DRAW_PER_TURN:
		draw_card(current_player)
	
	emit_signal("turn_started", current_player)

func end_turn() -> void:
	if game_ended:
		return
	
	current_player.end_turn()
	emit_signal("turn_ended", current_player)
	
	# 切换到下一个玩家
	current_player_index = (current_player_index + 1) % players.size()
	current_player = players[current_player_index]
	
	start_turn()

# 卡牌操作
func draw_card(player: Player) -> void:
	if deck.is_empty():
		_reshuffle_discard_pile()
	
	if not deck.is_empty():
		var card = deck.pop_back()
		player.draw_card(card)

func discard_card(card: BaseCard) -> void:
	discard_pile.append(card)

# 内部辅助方法
func _shuffle_deck() -> void:
	deck.shuffle()

func _reshuffle_discard_pile() -> void:
	deck.append_array(discard_pile)
	discard_pile.clear()
	_shuffle_deck()

func _deal_initial_cards() -> void:
	for player in players:
		for i in CardConfig.BASE_HAND_SIZE:
			draw_card(player)

# 玩家管理
func add_player(player: Player) -> void:
	players.append(player)

func remove_player(player: Player) -> void:
	players.erase(player)

# 游戏状态检查
func check_game_end() -> void:
	var alive_players = players.filter(func(p): return p.health > 0)
	if alive_players.size() == 1:
		end_game(alive_players[0])

# 目标选择验证
func is_valid_target(target: Player) -> bool:
	return target != null and target.can_be_targeted and target.health > 0 