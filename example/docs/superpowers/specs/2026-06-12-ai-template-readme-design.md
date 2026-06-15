# AI Template README Design

## 目标

将 example 工程整理成更适合模板项目和 AI 开发的文档入口。根 `README.md` 不再保留 Flutter 默认说明，而是作为模板入口导航；新增 `AI_DEV.md`，专门给 AI Agent 阅读，明确目录职责、硬性规则、常见任务步骤和禁止事项。

## 设计

- `README.md`：面向所有使用者，简短说明这是一个基于轻量级 Port/Infra + GetIt + Module 分层的 Flutter 模板项目，并链接到 `lib/quick_use.md`、`lib/ARCHITECTURE_TRADEOFFS.md`、`AI_DEV.md`。
- `AI_DEV.md`：面向 AI Agent，使用规则化、短句、任务清单格式，降低 AI 误放目录、绕过 Port/Infra、漏注册路由或依赖的概率。

## 文档分工

- `README.md`：入口和导航。
- `lib/quick_use.md`：初学者快速上手。
- `lib/ARCHITECTURE_TRADEOFFS.md`：架构优缺点和取舍。
- `AI_DEV.md`：AI 开发规则。

## 自检

- 未把详细说明堆进根 README。
- 已为 AI 开发提供独立规则文档。
- 已保留 `base/port` 作为接口抽象层、`infra` 作为实现层的描述。
