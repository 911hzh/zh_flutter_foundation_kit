# Flutter Foundation Kit

`flutter_foundation_kit` 是一个面向 Flutter 项目的基础框架 package。它把新项目常见的底层能力沉淀成可复用模块，让业务项目可以更快完成网络、日志、配置、状态容器、本地存储和通用工具的初始化。

这个 package 的目标不是生成完整业务模板，也不规定页面、路由、DI 或状态管理方案。它只提供基础能力和默认实现，业务项目可以按自己的工程结构组合使用。

> 当前 `pubspec.yaml` 中 `publish_to: "none"`，表示该 package 目前按内部基础库维护，暂不发布到 pub.dev。

## 适用场景

- 快速启动新的 Flutter 项目，减少重复搭建基础模块的成本。
- 在多个 App 或 demo 工程之间复用一致的网络、日志、配置和存储能力。
- 让业务代码优先依赖抽象协议，而不是直接绑定第三方插件或临时工具函数。
- 为 example、项目模板或脚手架提供一套稳定的底层 package。

## 设计目标

- **统一入口**：业务项目优先只导入 `package:flutter_foundation_kit/flutter_foundation_kit.dart`。
- **基础能力内聚**：网络、日志、Settings、Store、Repository、Port、Infra、工具类集中维护。
- **业务逻辑外置**：页面、路由、模块拆分、业务 Store 实现、接口模型和第三方 SDK 接入放在业务项目或 example 中。
- **实现可替换**：对外暴露协议和端口，默认实现只作为开箱即用的选择。
- **适合 AI 读取**：根目录提供 `README.md`、`architecture.md`、`ai.md`，让 AI 能快速理解框架目的和边界。

## 核心能力

### 网络

- `RestClient`：业务侧依赖的 REST 请求抽象。
- `RestClientImpl`：基于 Dio 的默认实现。
- `RestClientAdapter`：业务项目扩展 baseUrl、公共 headers、请求前处理和错误处理。
- `NetworkProxy`：网络代理配置能力。
- `RestResponse` / `RestRequestError`：统一响应与错误模型。

### 日志

- `LoggerProtocol`：基础库日志协议。
- `LoggerFactory`：全局 logger 工厂，可替换默认实现。
- `LoggerConfiguration`：日志输出配置。
- `DefaultLoggerImpl` / `LoggerTagImpl`：默认 logger 实现和 tag 包装。

### 配置

- `SettingsBase`：应用配置的最小协议。
- `SettingsLoader`：配置加载流程抽象。
- `AppEnvironment`：应用环境值对象，内置 `development`、`production`、`test`。

### Store

- `StoreBase`：基于 `ValueNotifier` 的轻量状态容器基类。
- `AuthStore` / `UserStore`：登录态和用户状态的可选基础抽象。

### 持久化

- `Repository`：按 key 读写 value 的最小仓储协议。
- `KeychainPort` / `PreferenceRepositoryPort`：安全存储和偏好设置端口。
- `KeyChainImpl` / `PreferenceRepositoryImpl`：基于 `flutter_keychain` 和 `shared_preferences` 的默认实现。

### 工具

- `JsonUtil`：JSON 编解码、格式化、异步解析和深拷贝。
- `Lazyload`：异步懒加载缓存工具。
- `Polling`：基于 `Lazyload` 的轮询工具。
- `Codable`：JSON 编解码协议。
- `MetaError` / `LocalizedError`：通用错误协议和错误模型。
- `BuildContextExtension`、`ListExtention`、`Generator`：常用扩展和辅助工具。

## 使用 example 生成新项目

可以把 `example` 当成 Flutter app 模板使用：

```bash
make create helloworldProject
```

命令会在当前仓库上一级生成 `../helloworldProject`，并把 Dart package name 转为 `helloworld_project`，默认 app id 转为 `com.example.helloworldproject`。

也可以按需指定 app id 和输出父目录：

```bash
make create helloworldProject BUNDLE_ID=com.company.helloworld OUTPUT=../apps
```

不传 `BUNDLE_ID` 时默认使用 `com.example.<project>`，不传 `OUTPUT` 时默认输出到当前仓库上一级目录。

生成后的项目默认使用 pub 版本依赖：

```yaml
flutter_foundation_kit: ^0.0.2
```

如果当前版本尚未发布到你的 pub 源，生成项目后的 `flutter pub get` 会因为依赖不可解析失败。此时需要先发布基础库，或后续扩展脚手架支持 git/path 依赖。

## 快速使用

### 1. 添加依赖

同一个 monorepo 内使用 path 依赖：

```yaml
dependencies:
  flutter_foundation_kit:
    path: ../flutter_foundation_kit
```

### 2. 统一导入

业务项目优先通过统一入口使用基础能力：

```dart
import 'package:flutter_foundation_kit/flutter_foundation_kit.dart';
```

不要优先 deep import `lib/api`、`lib/wcore`、`lib/cport`、`lib/infra`、`lib/cutil` 内部路径。除非某个 API 暂未进入统一入口，否则应先补充 `flutter_foundation_kit.dart` 的导出。

### 3. 配置网络请求

业务项目实现自己的 `RestClientAdapter`：

```dart
class AppRestClientAdapter extends RestClientAdapter {
  @override
  String getBaseUrl() => 'https://api.example.com';

  @override
  Future<Map<String, String>> getHeaders() async {
    return {'X-App': 'demo'};
  }
}
```

创建默认 REST client：

```dart
final client = RestClientImpl(
  restAdapter: AppRestClientAdapter(),
  networkProxy: AppNetworkProxy(),
);
```

### 4. 配置 Settings

业务项目继承 `SettingsBase` 定义自己的配置字段，并通过 `SettingsLoader` 决定当前环境和 asset 路径：

```dart
class AppSettings extends SettingsBase {
  AppSettings({
    required this.packageName,
    required this.environment,
    required this.baseUrl,
  });

  @override
  final String packageName;

  @override
  final AppEnvironment environment;

  final String baseUrl;

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      packageName: json['packageName'] as String,
      environment: AppEnvironment(json['environment'] as String),
      baseUrl: json['baseUrl'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'environment': environment.name,
        'baseUrl': baseUrl,
      };
}
```

### 5. 使用本地存储

安全数据使用 `KeyChainImpl`，普通偏好设置使用 `PreferenceRepositoryImpl`：

```dart
final keychain = KeyChainImpl();
await keychain.setValue('token', 'abc');

final preferences = PreferenceRepositoryImpl('user_settings');
await preferences.setValue('theme', 'dark');
```

## 文档导航

- `architecture.md`：当前 package 的架构、分层、依赖方向和维护约定。
- `ai.md`：给 AI agent 读取的上下文入口，说明应优先关注哪些文档和代码边界。
- `lib/README.md`：`lib` 目录内各文件职责说明。
- `example/`：演示如何在 Flutter App 中组合使用该基础库，后续会继续优化。

## 维护约定

- 新增对外能力时，同步从 `lib/flutter_foundation_kit.dart` 导出。
- 协议和端口优先放在 `api`、`wcore` 或 `cport`，具体插件实现放在 `infra`。
- 工具类放在 `cutil`，不要引入业务项目概念。
- `lib/port` 是历史兼容入口，新增端口统一放在 `lib/cport`。
- 业务页面、路由、业务模型、具体 DI 方案不进入 package core。
