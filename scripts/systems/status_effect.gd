extends Node
class_name StatusEffect

# 状态效果类型
enum EffectType {
	POISON,    # 中毒
	BURNING,   # 燃烧
	MEDICINE,  # 药效
	BUFF,      # 增益
	DEBUFF     # 减益
}

var effect_type: EffectType
var duration: int
var stacks: int
var owner: Node  # 状态效果的持有者

# 状态效果数值
var value: float = 0.0

func _init(type: EffectType, initial_stacks: int = 1, initial_duration: int = -1) -> void:
	effect_type = type
	stacks = initial_stacks
	duration = initial_duration

# 回合开始时触发
func on_turn_start() -> void:
	pass

# 回合结束时触发
func on_turn_end() -> void:
	if duration > 0:
		duration -= 1
	if duration == 0:
		queue_free()

# 当叠加层数时触发
func add_stacks(amount: int) -> void:
	stacks += amount

# 当减少层数时触发
func remove_stacks(amount: int) -> void:
	stacks -= amount
	if stacks <= 0:
		queue_free()

# 获取效果描述
func get_description() -> String:
	return ""

# 应用效果
func apply_effect() -> void:
	pass

# 移除效果
func remove_effect() -> void:
	pass 