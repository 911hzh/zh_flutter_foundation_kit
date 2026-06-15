# AI Template README Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将模板项目文档入口整理成适合人工和 AI Agent 快速使用的结构。

**Architecture:** 根 `README.md` 只承担入口导航职责；`AI_DEV.md` 承担 AI 开发规则职责；已有 `lib/quick_use.md` 和 `lib/ARCHITECTURE_TRADEOFFS.md` 继续分别服务初学者和架构说明。

**Tech Stack:** Markdown、Flutter template docs。

---

### Task 1: 更新 README 和新增 AI_DEV

**Files:**
- Modify: `README.md`
- Create: `AI_DEV.md`

- [ ] **Step 1: 更新根 README**

把 Flutter 默认 README 替换为模板项目入口说明，包含项目定位、快速入口、核心目录和适用方式。

- [ ] **Step 2: 新增 AI_DEV.md**

写明 AI Agent 修改项目时必须遵守的目录规则、禁止事项、常见任务步骤和验证清单。

- [ ] **Step 3: 验证 Markdown**

读取 `README.md` 和 `AI_DEV.md`，确认内容清晰且没有诊断错误。
