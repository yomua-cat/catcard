# 猫猫牌

这是一个使用 Godot 4.2 开发的卡牌游戏项目。

## 项目结构

```
├── scenes/     # 场景文件
├── scripts/    # 脚本文件
├── resources/  # 资源文件
├── addons/     # 插件目录
│   └── card_engine/  # Godot Card Game Framework
└── ui/        # UI相关文件
```

## 开发环境要求

- Godot 4.2
- 编辑器：推荐使用 VSCode + GDScript 插件

## 使用的框架

本项目使用了 [Godot Card Game Framework](https://github.com/db0/godot-card-game-framework) 作为卡牌游戏框架。这是一个功能丰富的卡牌游戏开发框架，提供以下特性：

- 完整的卡牌管理系统
- 拖放操作支持
- 卡牌堆管理
- 动画系统
- 多人游戏支持
- 模块化设计
- 丰富的自定义选项

## 如何运行

1. 克隆项目到本地
2. 使用 Godot 4.2 打开项目
3. 在项目设置中确保卡牌引擎插件已启用
4. 点击运行按钮即可启动游戏

## 开发规范

1. 场景文件(.tscn)存放在 scenes 目录
2. 脚本文件(.gd)存放在 scripts 目录
3. 资源文件(图片、音频等)存放在 resources 目录
4. UI相关场景和资源存放在 ui 目录

## 卡牌系统开发指南

1. 所有卡牌预制体应放在 `scenes/cards` 目录下
2. 卡牌数据配置文件存放在 `resources/cards` 目录下
3. 卡牌相关脚本存放在 `scripts/cards` 目录下
4. 使用框架提供的 API 进行卡牌逻辑开发

## 注意事项

1. 修改卡牌框架源码时需谨慎，最好创建自定义脚本进行功能扩展
2. 定期备份卡牌数据和自定义内容
3. 遵循框架的最佳实践和设计模式 