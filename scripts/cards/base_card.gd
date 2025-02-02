extends Node
class_name BaseCard

# 卡牌基本属性
var card_name: String
var description: String
var card_type: CardConfig.CardType
var target_type: CardConfig.TargetType

# 卡牌效果相关
var damage: float = 0.0
var defense: float = 0.0
var heal: float = 0.0

# 卡牌状态
var is_discarded: bool = false
var is_destroyed: bool = false
var owner = null  # 卡牌的持有者

# 初始化卡牌
func _init(data: Dictionary) -> void:
	card_name = data.get("name", "")
	description = data.get("description", "")
	card_type = data.get("type", CardConfig.CardType.UTILITY)
	target_type = data.get("target_type", CardConfig.TargetType.NONE)
	damage = data.get("damage", 0.0)
	defense = data.get("defense", 0.0)
	heal = data.get("heal", 0.0)

# 使用卡牌
func play(targets: Array) -> void:
	_pre_play()
	_execute(targets)
	_post_play()

# 卡牌使用前的处理
func _pre_play() -> void:
	pass

# 执行卡牌效果
func _execute(targets: Array) -> void:
	pass

# 卡牌使用后的处理
func _post_play() -> void:
	pass

# 检查是否可以使用
func can_play(player, targets: Array) -> bool:
	return true

# 获取卡牌描述
func get_description() -> String:
	return description

# 获取卡牌效果预览
func get_preview(targets: Array) -> String:
	return ""

# 丢弃卡牌
func discard() -> void:
	is_discarded = true

# 摧毁卡牌
func destroy() -> void:
	is_destroyed = true

# 复制卡牌
func duplicate() -> BaseCard:
	return load(get_script().resource_path).new({
		"name": card_name,
		"description": description,
		"type": card_type,
		"target_type": target_type,
		"damage": damage,
		"defense": defense,
		"heal": heal
	}) 