extends Node

# 基础卡牌实现
class BasicAttack extends BaseCard:
	func _init() -> void:
		super({
			"name": "攻击",
			"description": "对一名目标造成1点伤害",
			"type": CardConfig.CardType.ATTACK,
			"target_type": CardConfig.TargetType.SINGLE,
			"damage": 1.0
		})
	
	func _execute(targets: Array) -> void:
		if targets.size() > 0:
			targets[0].take_damage(damage)

class BasicDefense extends BaseCard:
	func _init() -> void:
		super({
			"name": "防御",
			"description": "获得1点防御值",
			"type": CardConfig.CardType.DEFENSE,
			"target_type": CardConfig.TargetType.SELF,
			"defense": 1.0
		})
	
	func _execute(targets: Array) -> void:
		owner.add_defense(defense)

class BasicHeal extends BaseCard:
	func _init() -> void:
		super({
			"name": "治疗",
			"description": "恢复1点血量",
			"type": CardConfig.CardType.HEAL,
			"target_type": CardConfig.TargetType.SELF,
			"heal": 1.0
		})
	
	func _execute(targets: Array) -> void:
		owner.heal(heal)

class PoisonCard extends BaseCard:
	func _init() -> void:
		super({
			"name": "毒药",
			"description": "施加2层"中毒"",
			"type": CardConfig.CardType.STATUS,
			"target_type": CardConfig.TargetType.SINGLE
		})
	
	func _execute(targets: Array) -> void:
		if targets.size() > 0:
			targets[0].add_status("poison", 2)

class DoubleStrike extends BaseCard:
	func _init() -> void:
		super({
			"name": "连击",
			"description": "对一名目标造成0.5点伤害,对一名目标造成0.5点伤害",
			"type": CardConfig.CardType.ATTACK,
			"target_type": CardConfig.TargetType.SINGLE,
			"damage": 0.5
		})
	
	func _execute(targets: Array) -> void:
		if targets.size() > 0:
			targets[0].take_damage(damage)
			targets[0].take_damage(damage)

class Guard extends BaseCard:
	func _init() -> void:
		super({
			"name": "格挡",
			"description": "获得2点防御值",
			"type": CardConfig.CardType.DEFENSE,
			"target_type": CardConfig.TargetType.SELF,
			"defense": 2.0
		})
	
	func _execute(targets: Array) -> void:
		owner.add_defense(defense)

class Recover extends BaseCard:
	func _init() -> void:
		super({
			"name": "回复",
			"description": "恢复0.5点血量,抽1张卡牌",
			"type": CardConfig.CardType.HEAL,
			"target_type": CardConfig.TargetType.SELF,
			"heal": 0.5
		})
	
	func _execute(targets: Array) -> void:
		owner.heal(heal)
		owner.draw_cards(1)

class TwinStrike extends BaseCard:
	func _init() -> void:
		super({
			"name": "双重打击",
			"description": "对一名目标造成1点伤害,对一名目标造成1点伤害",
			"type": CardConfig.CardType.ATTACK,
			"target_type": CardConfig.TargetType.SINGLE,
			"damage": 1.0
		})
	
	func _execute(targets: Array) -> void:
		if targets.size() > 0:
			targets[0].take_damage(damage)
			targets[0].take_damage(damage)

class ArmorEnhance extends BaseCard:
	func _init() -> void:
		super({
			"name": "护甲强化",
			"description": "获得1点防御值,获得1点固定防御值",
			"type": CardConfig.CardType.DEFENSE,
			"target_type": CardConfig.TargetType.SELF,
			"defense": 1.0
		})
	
	func _execute(targets: Array) -> void:
		owner.add_defense(defense)
		owner.add_permanent_defense(1.0)

class LifeDrain extends BaseCard:
	func _init() -> void:
		super({
			"name": "生命汲取",
			"description": "对一名目标造成1点伤害,恢复0.5点血量",
			"type": CardConfig.CardType.ATTACK,
			"target_type": CardConfig.TargetType.SINGLE,
			"damage": 1.0,
			"heal": 0.5
		})
	
	func _execute(targets: Array) -> void:
		if targets.size() > 0:
			targets[0].take_damage(damage)
			owner.heal(heal)

class HeavyStrike extends BaseCard:
	var used_attack_this_turn := false
	
	func _init() -> void:
		super({
			"name": "重击",
			"description": "对一名目标造成2点伤害,本回合无法再使用攻击牌",
			"type": CardConfig.CardType.ATTACK,
			"target_type": CardConfig.TargetType.SINGLE,
			"damage": 2.0
		})
	
	func _execute(targets: Array) -> void:
		if targets.size() > 0:
			targets[0].take_damage(damage)
			owner.set_attack_disabled(true)
	
	func can_play(player, targets: Array) -> bool:
		return not player.is_attack_disabled()

class SolidShield extends BaseCard:
	func _init() -> void:
		super({
			"name": "坚固护盾",
			"description": "获得3点防御值,下回合开始时获得1点防御值",
			"type": CardConfig.CardType.DEFENSE,
			"target_type": CardConfig.TargetType.SELF,
			"defense": 3.0
		})
	
	func _execute(targets: Array) -> void:
		owner.add_defense(defense)
		owner.add_next_turn_defense(1.0)

# 卡牌工厂方法
static func create_card(card_name: String) -> BaseCard:
	match card_name:
		"攻击": return BasicAttack.new()
		"防御": return BasicDefense.new()
		"治疗": return BasicHeal.new()
		"毒药": return PoisonCard.new()
		"连击": return DoubleStrike.new()
		"格挡": return Guard.new()
		"回复": return Recover.new()
		"双重打击": return TwinStrike.new()
		"护甲强化": return ArmorEnhance.new()
		"生命汲取": return LifeDrain.new()
		"重击": return HeavyStrike.new()
		"坚固护盾": return SolidShield.new()
		_: return null 