extends Node

# 卡牌相关信号
signal card_played(card_data: Dictionary)
signal card_drawn(card_data: Dictionary)
signal deck_shuffled
signal hand_updated

# 战斗相关信号
signal battle_started
signal battle_ended
signal turn_started
signal turn_ended
signal damage_dealt(target: Node, amount: int)
signal healing_received(target: Node, amount: int)

# UI相关信号
signal ui_button_pressed(button_name: String)
signal screen_changed(screen_name: String)
signal tooltip_requested(text: String, position: Vector2)
signal tooltip_hidden

# 系统相关信号
signal game_saved
signal game_loaded
signal settings_updated
signal achievement_unlocked(achievement_id: String)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# 用于触发卡牌播放事件
func emit_card_played(card_data: Dictionary) -> void:
	emit_signal("card_played", card_data)

# 用于触发抽卡事件
func emit_card_drawn(card_data: Dictionary) -> void:
	emit_signal("card_drawn", card_data)

# 用于触发战斗开始事件
func emit_battle_started() -> void:
	emit_signal("battle_started")

# 用于触发战斗结束事件
func emit_battle_ended() -> void:
	emit_signal("battle_ended")

# 用于触发回合开始事件
func emit_turn_started() -> void:
	emit_signal("turn_started")

# 用于触发回合结束事件
func emit_turn_ended() -> void:
	emit_signal("turn_ended")

# 用于触发伤害事件
func emit_damage_dealt(target: Node, amount: int) -> void:
	emit_signal("damage_dealt", target, amount)

# 用于触发治疗事件
func emit_healing_received(target: Node, amount: int) -> void:
	emit_signal("healing_received", target, amount) 