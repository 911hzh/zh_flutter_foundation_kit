# Repository Guidelines

## 项目结构与模块职责

本仓库是一个 Flutter 基础库 package，同时包含一个可复用的 example 应用模板。核心 package 代码放在 `lib/`，统一公开导出入口是 `lib/flutter_foundation_kit.dart`。可复用的 REST、Store、Logger、Settings、端口、基础设施适配器和工具类，应继续放在现有的 `lib/api`、`lib/wcore`、`lib/cport`、`lib/infra`、`lib/cutil` 目录中。

package 测试放在 `test/`；测试 JSON 资源在 `test/wcore/settings/`。`example/` 是 `make create` 使用的完整 Flutter app 模板，页面、路由、依赖注入和 demo 专属代码应留在这里，不要放进 package core。模板生成工具放在 `tool/`。

## 构建、测试与开发命令

- `flutter pub get`：安装根 package 依赖。
- `make analyze`：执行 `flutter analyze lib test --no-fatal-infos --no-fatal-warnings`。
- `make test`：运行根 package 的 Flutter 测试。
- `make ci`：运行根 package 的 analyze 和 test。
- `make format`：按 `analysis_options.yaml` 的 formatter 配置格式化 `lib/`、`test/`、`example/`。
- `python3 -m unittest tool/test_create_example_project.py`：测试 example 项目生成器。
- `make create helloworldProject BUNDLE_ID=com.company.helloworld OUTPUT=../apps`：基于 `example/` 生成新 app。
- `cd example && flutter pub get && flutter run`：本地运行模板 app。

## 代码风格与命名约定

使用 Dart/Flutter 默认风格和两空格缩进。修改已有代码时遵循当前文件命名风格；本仓库已有 `RestClient.dart`、`StoreBase.dart`、`json_util_test.dart` 等命名，不要为了统一风格做无关重命名。

新增对外 API 时，同步从 `lib/flutter_foundation_kit.dart` 导出，避免只提供 deep import。优先复用现有实现、标准库和当前依赖，非必要不新增依赖。package core 保持业务无关；产品页面、路由和 DI 组装留在 `example/`。

## 测试规范

Dart 测试放在 `test/`，文件命名为 `*_test.dart`。尽量按源码区域镜像测试路径，例如 `test/cutil/json_util_test.dart` 对应 `lib/cutil/JsonUtil.dart`。修改生成器时同步更新 `tool/test_create_example_project.py`。先运行最小相关测试，再在较大改动后运行 `make ci`、生成器测试和 example 的 analyze/test。

## 版本与模板同步

修改 `pubspec.yaml` 的 package 版本时，必须在同一改动中同步：

- `tool/create_example_project.py` 中的 `DEFAULT_FOUNDATION_VERSION`。
- `tool/test_create_example_project.py` 中默认生成版本的断言。
- `FOUNDATION_KIT_DETAIL.md`、`QUICK_PROJECT_README.md`、`example/FEATURE_LOG.md` 中提到的生成依赖版本。
- 运行 `cd example && flutter pub get`，同步 `example/pubspec.lock` 中的 path 依赖版本。
- 在 `CHANGELOG.md` 增加对应版本条目。

## 提交与 PR 规范

提交要保持聚焦。commit 标题可以简短，但提交正文需要整理清楚本次提交内容，至少说明：

- 主要修改了什么。
- 为什么需要修改。
- 跑过哪些验证命令。
- 是否包含 package API、模板生成逻辑或 example UI 行为变化。

PR 也应包含变更内容、原因、验证命令；如果涉及 `example/` 可见 UI，补充截图或录屏。关联 issue 时在 PR 中说明。

## Agent 专用说明

如果仓库根目录存在 `.codegraph/`，定位代码时优先使用 CodeGraph，再考虑 grep/find。不要修改生成的平台文件或用户本地文件，除非任务明确要求。不要提交 `.DS_Store`、`.codegraph/` 这类本地或索引产物。
