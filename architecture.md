# Flutter Foundation Kit 架构

`flutter_foundation_kit` 是一个面向 Flutter 项目的基础框架 package。它提供可复用的底层能力，不是完整应用模板。页面、路由、依赖注入方式、业务模型、功能流程等应用层内容，应保留在宿主 App 或 `example` 中。

## 架构目标

这个 package 围绕三个目标设计：

- 用一个依赖提供 Flutter 项目常见的基础能力。
- 让业务代码依赖稳定抽象，而不是直接依赖具体插件。
- 在需要快速启动项目时，提供可直接使用的默认实现。

## 公开入口

推荐的公开导入方式是：

```dart
import 'package:flutter_foundation_kit/flutter_foundation_kit.dart';
```

`lib/flutter_foundation_kit.dart` 是 package 的统一导出入口。所有希望给业务项目使用的 API，都应该从这个文件导出。业务代码应避免直接 deep import `package:flutter_foundation_kit/wcore/...` 这类内部路径，除非该 API 明确不属于公开使用面。

## 分层概览

```text
宿主 App / Example
  - 页面、路由、功能模块、DI、具体业务 Store
  - 依赖 flutter_foundation_kit 公开 API

flutter_foundation_kit
  api/
    REST 请求协议和响应模型
  wcore/
    核心抽象和框架级默认实现
  cport/
    平台能力或基础设施能力端口
  infra/
    基于 Flutter 插件的默认基础设施实现
  cutil/
    通用工具类和扩展
```

## 目录职责

### `lib/api`

`api` 存放对外网络请求协议和数据模型：

- `RestClient`
- `RestClientBase`
- `RestResponse`
- `RestRequestError`

这一层定义业务代码如何发起 REST 请求。当前默认实现基于 Dio，但业务代码应尽量依赖 `RestClient` 抽象。

### `lib/wcore`

`wcore` 存放框架核心能力：

- `wcore/apiImpl`：网络默认实现和辅助能力。
- `wcore/logger`：日志抽象和默认日志实现。
- `wcore/settings`：配置抽象和加载流程。
- `wcore/store`：轻量 Store 抽象。
- `Repository`：最小 key/value 持久化协议。

`wcore` 可以承载 package 级别的基础能力协调，但不应包含页面逻辑、路由定义、具体业务模型或 App 专属服务注册。

### `lib/cport`

`cport` 存放能力端口。端口用于描述 package 或业务项目需要什么基础设施能力，但不绑定具体插件。

当前端口：

- `KeychainPort`
- `PreferenceRepositoryPort`

新增端口统一放在这里。`lib/port` 是历史兼容入口，不应再新增文件。

### `lib/infra`

`infra` 存放默认基础设施适配器。这里的文件是具体实现，因此可以依赖 Flutter 插件或第三方 package。

当前实现：

- `KeyChainImpl`
- `PreferenceRepositoryImpl`

业务项目可以直接使用这些默认实现快速启动，也可以为对应端口提供自己的实现。

### `lib/cutil`

`cutil` 存放通用工具类。这里的代码应保持无业务含义，也不应感知 App 模块。

当前工具能力包括：

- JSON 工具。
- 懒加载和轮询。
- 错误模型。
- Codable 协议。
- List 和 BuildContext 扩展。
- 简单 ID 生成。

## 依赖方向

推荐的依赖方向是：

```text
业务代码
  -> flutter_foundation_kit.dart
    -> 抽象协议
    -> 默认实现
      -> 第三方 package / Flutter 插件
```

约定：

- 业务模块应尽量依赖 `RestClient`、`LoggerProtocol`、`SettingsBase`、`StoreBase`、`Repository` 或具体端口。
- 默认实现可以依赖 Dio、`logger`、`shared_preferences`、`flutter_keychain`。
- 端口不应暴露第三方插件类型。
- 工具类应保持和业务概念无关。

## 哪些内容适合放进这个 package

适合放入：

- 多个 Flutter App 都会复用的抽象。
- 通用基础设施适配器。
- 响应、错误、配置、日志、持久化等基础能力。
- 有测试覆盖的小型通用工具。
- 能减少重复项目搭建成本的轻量基类。

不适合放入：

- 某个具体产品的页面 widget。
- 路由表。
- 具体功能的 Cubit/Bloc。
- 产品专属 API model。
- App 专属依赖注入模块。
- 只有单个 App 需要的第三方 SDK 初始化。

## 当前取舍

为了让内部项目更快启动，当前 package 把部分默认实现直接放在主 package 中：

- `RestClientImpl` 使用 Dio。
- `DefaultLoggerImpl` 使用 `logger`。
- `KeyChainImpl` 使用 `flutter_keychain`。
- `PreferenceRepositoryImpl` 使用 `shared_preferences`。

这种做法有利于内部复用，但也意味着基础包带有一定实现选择。如果后续要把它扩展成更通用或可发布的 framework，可以考虑把网络、存储、日志等默认实现拆成更小的 adapter package。

## 演进规则

- 新增公开 API 时，同步导出到 `lib/flutter_foundation_kit.dart`。
- 新增能力端口时，放到 `lib/cport`。
- 第三方插件适配器放到 `lib/infra`。
- 业务示例放在 `example`，不要放进 package core。
- package 边界发生变化时，同步更新 `README.md`、`architecture.md` 和 `ai.md`。
- 共享行为变化时补充或更新测试，尤其是工具、配置、持久化和网络转换逻辑。
