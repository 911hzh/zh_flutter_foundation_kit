# Flutter Foundation Kit Example Template

这是一个基于轻量级 Port/Infra + GetIt + Module 分层的 Flutter 模板项目。它的目标是让开发者或 AI Agent 在 `git clone` 后，可以快速知道页面、接口抽象、第三方 SDK 实现、依赖注册、路由和公共 UI 应该放在哪里。

## 快速入口

- 初学者快速上手：`lib/quick_use.md`
- 架构说明和取舍：`lib/ARCHITECTURE_TRADEOFFS.md`
- AI 开发规则：`AI_DEV.md`
- 功能记录：`FEATURE_LOG.md`
- `lib` 目录总览：`lib/README.md`

## 核心目录

- `lib/module`：页面、Cubit、VM、模块内 Widget。
- `lib/base/port`：第三方 SDK 或平台能力的接口抽象。
- `lib/infra`：`base/port` 中接口的具体实现。
- `lib/getIt`：依赖注入和对象注册。
- `lib/route`：路由表和全局导航能力。
- `lib/uikit`：多个模块共享的 UI 组件。
- `lib/base/api`：示例网络 API 封装。
- `lib/base/store`：共享状态、本地持久化和 Store 示例。

## 最小规则

页面和业务放 `module`，接口抽象放 `base/port`，具体实现放 `infra`，依赖注册放 `getIt`，路由放 `route`，公共 UI 放 `uikit`。

## 适合的使用方式

如果你是第一次使用该模板，先阅读 `lib/quick_use.md`。如果你准备让 AI Agent 辅助开发，先把 `AI_DEV.md` 作为项目规则上下文提供给 AI。每次新增功能后，将功能入口、涉及目录和验证方式记录到 `FEATURE_LOG.md`。
