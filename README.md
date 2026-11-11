# Flutter Foundation Kit

这个仓库提供两个使用方案：一个是直接使用 `flutter_foundation_kit` 基础库，另一个是基于 Kit 生成一个已经搭好基础架构的 Flutter 项目。

## 方案一：使用 Foundation Kit 基础库

`flutter_foundation_kit` 是一个可复用 Flutter package，提供网络、日志、配置、Store、本地存储、Repository、错误模型和通用工具等基础能力。适合已经有项目结构，只想接入基础能力的 Flutter 项目。

详细说明见：[FOUNDATION_KIT_DETAIL.md](FOUNDATION_KIT_DETAIL.md)。

## 方案二：生成基于 Kit 的模板项目

`example` 是一个已经基于 Kit 搭好的 Flutter app 模板。它已经接入推荐目录结构、路由、依赖注入、网络基础层、Store、Settings、Logger 和基础测试。生成出来的目录不是空工程，可以直接作为新项目开始开发。

一条命令生成项目：

```bash
make create helloworldProject
```

可选指定 app id 和输出目录：

```bash
make create helloworldProject BUNDLE_ID=com.company.helloworld OUTPUT=../apps
```

模板项目详情见：[QUICK_PROJECT_README.md](QUICK_PROJECT_README.md)。

## 适用场景

- 已有 Flutter 项目，只想接入基础能力：看 [FOUNDATION_KIT_DETAIL.md](FOUNDATION_KIT_DETAIL.md)。
- 新建 Flutter 项目，希望目录、路由、DI、网络、Store、Settings 等基础设施都已经搭好：看 [QUICK_PROJECT_README.md](QUICK_PROJECT_README.md)。

## 文档导航

- `FOUNDATION_KIT_DETAIL.md`：Kit 基础库能力、快速使用和维护约定。
- `QUICK_PROJECT_README.md`：基于 Kit 的模板项目、生成命令和新项目内置能力。
- `architecture.md`：当前 package 的架构、分层、依赖方向和维护约定。
- `ai.md`：给 AI agent 读取的上下文入口，说明应优先关注哪些文档和代码边界。
- `lib/README.md`：`lib` 目录内各文件职责说明。
- `example/README.md`：模板工程自身的目录入口和使用约定。
