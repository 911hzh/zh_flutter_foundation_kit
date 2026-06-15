# Lib Directory Docs Design

## 背景

`packages/flutter_foundation_kit/example` 是 `flutter_foundation_kit` 的示例工程。当前 `lib` 下已经形成了若干外层目录：`base`、`getIt`、`infra`、`module`、`route`、`uikit`，其中 `lib/base/port` 用于放置接口抽象层，`lib/infra` 用于放置这些 Port 的实现，`lib/getIt` 用于依赖注册，`lib/module` 用于组织各个示例模块。

## 目标

为 `lib` 外层目录补充 Markdown 说明文档，让读者不用先阅读所有 Dart 文件，也能理解每个目录的职责边界、适合放置的内容，以及目录之间的依赖关系。

## 文档范围

- 在 `lib/README.md` 写总览、外层目录职责和 Mermaid 结构图。
- 在 `lib/base/README.md` 说明基础能力目录的职责。
- 在 `lib/base/port/README.md` 说明 Port/接口抽象层，强调第三方 SDK 接入接口优先放在这里。
- 在 `lib/base/api/README.md` 说明当前示例网络 API 封装的作用，避免误写成 Port 抽象层。
- 在 `lib/base/store/README.md` 说明状态和持久化 Store 示例。
- 在 `lib/infra/README.md` 说明 Port 的实现层。
- 在 `lib/getIt/README.md` 说明依赖注入和注册入口。
- 在 `lib/module/README.md` 说明模块目录和 demo 页面组织方式。
- 在 `lib/route/README.md` 说明路由注册和导航 key。
- 在 `lib/uikit/README.md` 说明公共 UI 组件层。

## 结构原则

业务或页面模块依赖 Port 抽象，不直接依赖第三方 SDK。Infra 负责实现 Port，并通过 getIt 注册给上层使用。Module 目录只组织功能模块、页面、Cubit 和展示逻辑。Route 负责页面入口，UIKit 负责可复用 UI 组件。

## 结构图形式

总览文档使用 Mermaid `flowchart TD`。图中展示 `module -> base/port -> infra -> getIt` 的依赖关系，也展示 `route`、`uikit` 与模块的辅助关系。

## 自检

- 未使用 `TBD` 或占位内容。
- 已明确 `lib/base/port` 才是 Port/接口抽象层。
- 已保留 `lib/base/api` 的当前实际职责，不把它描述为 Port 抽象层。
- 文档范围只涉及 Markdown 文件，不修改业务代码。
