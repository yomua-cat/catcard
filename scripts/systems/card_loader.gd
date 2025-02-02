extends Node
class_name CardLoader

# 卡牌数据格式错误
class CardParseError extends Error:
	var line_number: int
	var message: String
	
	func _init(line: int, msg: String) -> void:
		line_number = line
		message = msg

# 加载卡牌配置文件
static func load_cards_from_file(file_path: String) -> Array:
	var cards := []
	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("无法打开文件：" + file_path)
		return cards
	
	var line_number := 0
	while not file.eof_reached():
		line_number += 1
		var line := file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue
		
		try:
			var card_data := _parse_card_line(line, line_number)
			cards.append(card_data)
		except CardParseError as e:
			push_error("解析错误 (第%d行): %s" % [e.line_number, e.message])
	
	return cards

# 解析单行卡牌数据
static func _parse_card_line(line: String, line_number: int) -> Dictionary:
	var parts := line.split(":", true, 1)
	if parts.size() != 2:
		var error := CardParseError.new(line_number, "无效的卡牌格式，应为 '名称:描述'")
		push_error(error)
		return {}
	
	var name := parts[0].strip_edges()
	var description := parts[1].strip_edges()
	
	if name.is_empty():
		var error := CardParseError.new(line_number, "卡牌名称不能为空")
		push_error(error)
		return {}
	
	if description.is_empty():
		var error := CardParseError.new(line_number, "卡牌描述不能为空")
		push_error(error)
		return {}
	
	# 解析效果
	var effects := _parse_effects(description)
	
	return {
		"name": name,
		"description": description,
		"effects": effects,
		"line_number": line_number
	}

# 解析卡牌效果
static func _parse_effects(description: String) -> Array:
	var effects := []
	var effect_texts := description.split(",")
	
	for effect in effect_texts:
		effect = effect.strip_edges()
		if effect.is_empty():
			continue
		
		# 解析效果类型和数值
		var effect_data := _parse_single_effect(effect)
		if not effect_data.is_empty():
			effects.append(effect_data)
	
	return effects

# 解析单个效果
static func _parse_single_effect(effect: String) -> Dictionary:
	# 基础效果模式匹配
	if "造成" in effect and "点伤害" in effect:
		var damage := _extract_number(effect)
		return {"type": "damage", "value": damage}
	
	elif "获得" in effect and "点防御" in effect:
		var defense := _extract_number(effect)
		return {"type": "defense", "value": defense}
	
	elif "恢复" in effect and "点血量" in effect:
		var heal := _extract_number(effect)
		return {"type": "heal", "value": heal}
	
	elif "抽" in effect and "张卡牌" in effect:
		var draw := _extract_number(effect)
		return {"type": "draw", "value": draw}
	
	elif "施加" in effect and "层" in effect:
		var status_parts := effect.split("层")
		if status_parts.size() >= 2:
			var stacks := _extract_number(status_parts[0])
			var status_type := status_parts[1].strip_edges().trim_prefix("\"").trim_suffix("\"")
			return {"type": "status", "status_type": status_type, "stacks": stacks}
	
	return {}

# 从文本中提取数字
static func _extract_number(text: String) -> float:
	var regex := RegEx.new()
	regex.compile("\\d+(\\.\\d+)?")
	var result := regex.search(text)
	if result:
		return result.get_string().to_float()
	return 0.0 