# 批量操作文档

> 🔴 **最高优先级提示**：
> 1. 在进行任何批量操作之前，请务必仔细阅读 [批量操作流程指南](./BATCH_OPERATION_PROCESS.md)。
> 2. 本文档包含完整的系统说明，建议按照以下索引顺序阅读。

## 📑 文档完整索引

### 第一部分：核心流程（必读）
1. [核心文档说明](#核心文档)
2. [操作前检查清单](#操作前检查清单)

### 第二部分：系统结构
1. [目录结构说明](#目录结构)
2. [快速导航链接](#快速导航)

### 第三部分：详细规范
1. [批量操作管理系统](#批量操作管理系统)
2. [系统目录结构](#目录结构-1)
3. [状态文件格式](#状态文件格式-statusjson)
4. [备份策略说明](#备份策略)
5. [日志系统详解](#日志系统)
6. [使用规范](#使用规范)
7. [恢复流程](#恢复流程)

> ⚠️ **重要提示**：
> - 请确保在开始操作前完整阅读本文档
> - 特别注意备份和状态管理相关内容
> - 严格遵循文档中描述的操作流程
> - 如遇问题，请参考恢复流程章节

## 📚 核心文档

### [批量操作流程指南](./BATCH_OPERATION_PROCESS.md)（🔴 必读）

该指南包含以下关键内容：

1. **操作流程概览**
   - 标准操作流程图
   - 完整执行步骤

2. **关键阶段说明**
   - 准备阶段
   - 方案确认阶段
   - 风险评估阶段
   - 执行准备阶段
   - 分步执行阶段
   - 完整性验证阶段

3. **异常处理与回滚**
   - 异常处理流程
   - 回滚操作指南

4. **实际操作示例**
   - 单个数值调整示例
   - 批量属性调整示例

## 📂 目录结构

```
.batch_operations/
├── README.md                    # 当前文件：主要文档索引
├── BATCH_OPERATION_PROCESS.md   # 批量操作流程指南（核心文档）
└── [batch_id]/                 # 具体批次操作目录
    ├── status/                 # 状态记录
    ├── backup/                 # 备份文件
    └── logs/                   # 操作日志
```

## 🔍 快速导航

1. [完整操作流程](./BATCH_OPERATION_PROCESS.md#操作流程概览)
2. [准备阶段说明](./BATCH_OPERATION_PROCESS.md#1-准备阶段)
3. [方案确认流程](./BATCH_OPERATION_PROCESS.md#2-方案确认阶段)
4. [风险评估指南](./BATCH_OPERATION_PROCESS.md#3-风险评估阶段)
5. [执行准备清单](./BATCH_OPERATION_PROCESS.md#4-执行准备阶段)
6. [执行阶段说明](./BATCH_OPERATION_PROCESS.md#5-分步执行阶段)
7. [验证阶段指南](./BATCH_OPERATION_PROCESS.md#6-完整性验证阶段)
8. [异常处理流程](./BATCH_OPERATION_PROCESS.md#异常处理流程)
9. [操作示例参考](./BATCH_OPERATION_PROCESS.md#操作示例)

## 📋 操作前检查清单

- [ ] 已完整阅读批量操作流程指南
- [ ] 已创建操作方案文档
- [ ] 已完成风险评估
- [ ] 已准备好备份方案
- [ ] 已确认所有必要工具可用
- [ ] 已获得必要的操作权限

# 批量操作管理系统

## 目录结构
```
.batch_operations/
├── status/     # 状态文件目录
│   ├── current/   # 当前执行的批量操作状态
│   └── history/   # 历史操作状态记录
├── backup/     # 操作备份目录
│   ├── pre_batch/    # 批量操作前的完整备份
│   └── checkpoints/  # 执行过程中的检查点备份
├── logs/       # 日志文件目录
│   ├── operations/   # 操作日志
│   ├── errors/       # 错误日志
│   └── audit/        # 审计日志
└── temp/       # 临时文件目录
```

## 状态文件格式 (status/*.json)
```json
{
    "batch_id": "BATCH_20240205_001",
    "operation_type": "BALANCE_ADJUSTMENT",
    "start_time": "2024-02-05T12:00:00Z",
    "current_step": 1,
    "total_steps": 5,
    "steps_status": {
        "1": {
            "name": "方案确认",
            "status": "PENDING",
            "sub_steps": {
                "1.1": {"name": "修改范围确认", "status": "PENDING"},
                "1.2": {"name": "具体数值确认", "status": "PENDING"},
                "1.3": {"name": "影响范围确认", "status": "PENDING"}
            },
            "start_time": null,
            "end_time": null
        }
        // ... 其他步骤
    },
    "files_affected": [
        "resources/cards/basic_deck.txt"
    ],
    "backup_locations": {
        "pre_batch": "backup/pre_batch/BATCH_001/",
        "current_checkpoint": "backup/checkpoints/BATCH_001/step_1/"
    }
}
```

## 备份策略
1. **完整备份**
   - 位置：`backup/pre_batch/BATCH_[ID]/`
   - 时机：批量操作开始前
   - 内容：所有相关文件的完整副本

2. **检查点备份**
   - 位置：`backup/checkpoints/BATCH_[ID]/step_[N]/`
   - 时机：每个步骤执行前
   - 内容：当前步骤涉及的文件

## 日志系统
1. **操作日志** (`logs/operations/`)
   ```
   [2024-02-05 12:00:00] BATCH_001 STEP_1 START
   [2024-02-05 12:00:05] BATCH_001 STEP_1.1 CONFIRM
   ```

2. **错误日志** (`logs/errors/`)
   ```
   [2024-02-05 12:00:10] ERROR BATCH_001 STEP_1.2
   Details: Invalid value range
   ```

3. **审计日志** (`logs/audit/`)
   ```
   [2024-02-05 12:00:00] USER_ACTION BATCH_001 CREATE
   [2024-02-05 12:00:05] SYSTEM_ACTION BATCH_001 BACKUP
   ```

## 使用规范

### 1. 状态管理
- 所有状态变更必须写入状态文件
- 状态文件必须包含完整的操作历史
- 每个步骤必须有明确的开始和结束标记

### 2. 备份管理
- 操作前必须创建完整备份
- 每个检查点必须创建增量备份
- 备份必须包含元数据信息

### 3. 日志管理
- 所有操作必须记录日志
- 错误必须包含完整的上下文
- 审计日志必须记录所有用户操作

### 4. 临时文件
- 使用 `temp/` 目录存储临时数据
- 操作完成后必须清理临时文件
- 临时文件必须包含批次ID标识

## 恢复流程
1. 读取最新状态文件
2. 验证当前系统状态
3. 确认最后成功的检查点
4. 从检查点恢复数据
5. 请求用户确认继续 