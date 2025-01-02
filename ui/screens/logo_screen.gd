extends Control

@onready var logo_texture: TextureRect = $LogoTexture

func _ready() -> void:
	# 设置Logo纹理
	if not logo_texture.texture:
		# 如果没有设置纹理,使用默认纹理
		var default_texture = load("res://assets/textures/logo.png")
		if default_texture:
			logo_texture.texture = default_texture
	
	# 设置Logo位置
	logo_texture.pivot_offset = logo_texture.size / 2
	logo_texture.position = get_viewport_rect().size / 2 - logo_texture.size / 2
	
	# 添加缩放动画
	var tween = create_tween()
	tween.tween_property(logo_texture, "scale", Vector2(1.1, 1.1), 1.0)
	tween.tween_property(logo_texture, "scale", Vector2(1.0, 1.0), 1.0)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		# 窗口大小改变时重新居中Logo
		logo_texture.position = get_viewport_rect().size / 2 - logo_texture.size / 2 
