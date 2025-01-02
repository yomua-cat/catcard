extends Area3D
class_name Card

# 卡牌基本属性
var card_data := {
	"id": "",
	"name": "",
	"description": "",
	"cost": 0,
	"type": "",
	"rarity": "",
	"effects": []
}

# 卡牌状态
var is_selected := false
var is_playable := true
var original_position: Vector3
var original_rotation: Vector3

# 3D模型相关
@onready var card_mesh: MeshInstance3D = $CardMesh
@onready var card_material: StandardMaterial3D = $CardMesh.get_surface_override_material(0)
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

# 信号
signal card_selected(card: Card)
signal card_played(card: Card)
signal card_hovered(card: Card)
signal card_unhovered(card: Card)

func _ready() -> void:
	original_position = position
	original_rotation = rotation
	setup_input()

func setup_input() -> void:
	# 设置碰撞检测
	collision_shape.input_ray_pickable = true
	
	# 连接信号
	area_entered.connect(_on_mouse_entered)
	area_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func initialize(data: Dictionary) -> void:
	card_data = data
	update_appearance()

func update_appearance() -> void:
	# 更新卡牌外观
	# 这里需要根据实际的3D模型和材质来实现
	pass

func play() -> void:
	if not is_playable:
		return
	
	get_node("/root/EventBus").emit_card_played(card_data)
	emit_signal("card_played", self)

func _on_mouse_entered(_area: Area3D = null) -> void:
	if not is_playable:
		return
	
	# 卡牌悬停效果
	var tween = create_tween()
	tween.tween_property(self, "position:y", original_position.y + 0.5, 0.2)
	emit_signal("card_hovered", self)

func _on_mouse_exited(_area: Area3D = null) -> void:
	if not is_playable:
		return
	
	# 恢复原始位置
	var tween = create_tween()
	tween.tween_property(self, "position", original_position, 0.2)
	emit_signal("card_unhovered", self)

func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not is_playable:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_selected = true
			emit_signal("card_selected", self)

# 设置卡牌是否可播放
func set_playable(value: bool) -> void:
	is_playable = value
	# 更新视觉效果
	if not is_playable:
		card_material.albedo_color = Color(0.5, 0.5, 0.5, 1.0)
	else:
		card_material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)

# 获取卡牌数据
func get_card_data() -> Dictionary:
	return card_data

# 设置卡牌位置和旋转
func set_card_transform(pos: Vector3, rot: Vector3) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", pos, 0.3)
	tween.tween_property(self, "rotation", rot, 0.3) 