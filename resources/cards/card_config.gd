extends Resource
class_name CardConfig

# 卡牌类型枚举
enum CardType {
	ATTACK,    # 攻击类
	DEFENSE,   # 防御类
	HEAL,      # 治疗类
	UTILITY,   # 功能类
	STATUS,    # 状态类
	SPECIAL    # 特殊类
}

# 目标类型枚举
enum TargetType {
	NONE,           # 无目标
	SINGLE,         # 单体目标
	MULTIPLE,       # 多个目标
	ALL,            # 所有目标
	SELF,           # 自身
	ALL_EXCEPT_SELF # 除自身外的所有目标
}

# 基础配置
const BASE_HAND_SIZE := 10       # 基础手牌上限
const BASE_DRAW_PER_TURN := 1    # 每回合抽牌数
const BASE_HP := 10              # 基础生命值
const BASE_DEFENSE := 0          # 基础防御值

# 伤害计算相关
const DAMAGE_SCALE := 0.1        # 伤害计算的最小单位(用于0.1的倍数) 