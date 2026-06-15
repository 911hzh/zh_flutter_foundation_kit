# Lib Directory Docs Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 example 工程 `lib` 外层目录补充职责说明和结构图。

**Architecture:** 使用每个目录一个 `README.md` 的方式记录职责边界。总览文档放在 `lib/README.md`，并通过 Mermaid 图描述 `module`、`base/port`、`infra`、`getIt`、`route`、`uikit` 的关系。

**Tech Stack:** Flutter、Dart、Markdown、Mermaid。

---

### Task 1: 创建目录说明文档

**Files:**
- Create: `lib/README.md`
- Create: `lib/base/README.md`
- Create: `lib/base/port/README.md`
- Create: `lib/base/api/README.md`
- Create: `lib/base/store/README.md`
- Create: `lib/infra/README.md`
- Create: `lib/getIt/README.md`
- Create: `lib/module/README.md`
- Create: `lib/route/README.md`
- Create: `lib/uikit/README.md`

- [ ] **Step 1: 写总览文档**

在 `lib/README.md` 中写明外层目录职责，并加入 Mermaid 结构图。

- [ ] **Step 2: 写 base 相关文档**

为 `base`、`base/port`、`base/api`、`base/store` 写说明，明确 `base/port` 是接口抽象层。

- [ ] **Step 3: 写实现、注册、模块、路由和 UI 文档**

为 `infra`、`getIt`、`module`、`route`、`uikit` 写说明，保持与现有目录职责一致。

- [ ] **Step 4: 验证新增文档**

运行文件搜索确认 README 已创建，读取关键文档检查内容中没有把 `base/api` 误写为 Port 抽象层。
