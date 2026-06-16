# Quick Project README

本文档说明通过 `example` 模板生成的新 Flutter 项目已经集成了什么能力，以及一个项目刚开始搭建时哪些基础结构已经准备好。

## 生成可直接开发的模板项目

在 `zh_flutter_foundation_kit` 仓库根目录执行：

```bash
make create helloworldProject
```

默认行为：

- 输出目录：`../helloworldProject`
- Dart package name：`helloworld_project`
- app id：`com.example.helloworldproject`
- 基础库依赖：`flutter_foundation_kit: ^0.0.2`

也可以指定 app id 和输出父目录：

```bash
make create helloworldProject BUNDLE_ID=com.company.helloworld OUTPUT=../apps
```

生成完成后进入项目：

```bash
cd ../helloworldProject
flutter pub get
```

## 新项目已经具备什么

生成出来的项目不是空 Flutter 工程，而是已经搭好基础架构的 app 模板。你可以直接开始写业务页面、接口、Store 或第三方 SDK 接入代码。

### 1. 应用分层已经建立

核心目录已经准备好：

```text
lib/
  module/
    usecase/      页面、Cubit、VM、页面内 Widget
    route/        路由表和全局导航 key
    getIt/        依赖注入入口和注册模块
  base/
    api/          示例网络 API、网络模型、RestClientAdapter
    port/         第三方 SDK 或平台能力的业务抽象
    store/        登录态、用户数据、Settings 等共享状态
  infra/          base/port 的具体实现
  e_uikit/        多页面复用 UI 组件
```

这意味着项目刚创建时，页面层、接口抽象层、基础设施实现层、路由层、依赖注入层、公共 UI 层都已经有明确位置。

### 2. 基础库依赖已经接好

新项目默认依赖：

```yaml
flutter_foundation_kit: ^0.0.2
```

项目代码可以直接使用基础库提供的网络、日志、Settings、Store、Repository、持久化和工具能力。

### 3. 依赖注入已经建立

模板已集成 GetIt + injectable：

```text
lib/module/getIt/Injection.dart
lib/module/getIt/Injection.config.dart
lib/module/getIt/RegisterModule.dart
lib/module/getIt/GetItInstanceName.dart
```

项目刚生成时已经有依赖初始化入口，后续新增 Store、Repository、网络客户端、Port 实现或 SDK adapter 时，可以继续在这里注册。

### 4. 路由能力已经建立

模板已提供：

```text
lib/module/route/RouteConfig.dart
lib/module/route/GlobalNavigatorKey.dart
```

新增页面后，把页面路径注册到 `RouteConfig.dart`，需要全局导航时使用 `GlobalNavigatorKey.dart`。

### 5. 网络基础层已经建立

模板已包含示例网络结构：

```text
lib/base/api/AppApiClient.dart
lib/base/api/UserApi.dart
lib/base/api/AppRestClientAdapter.dart
lib/base/api/AppNetworkProxy.dart
lib/base/api/model/
```

项目刚开始时已经有网络 API 放置位置、模型放置位置，以及接入 `flutter_foundation_kit` REST Client 的 adapter 示例。

### 6. 本地状态和配置已经建立

模板已包含：

```text
lib/base/store/auth/
lib/base/store/user/
lib/base/store/settings/
lib/base/store/settings/development.json
lib/base/store/settings/release.json
```

登录态、用户数据、Settings 加载、环境配置 asset 都已经有示例实现。新项目可以直接在这些基础上改造业务字段。

### 7. 日志和工具示例已经建立

模板中已经有 Logger、Settings、Store、网络请求和工具类的 demo 页面。你可以通过这些页面查看 `flutter_foundation_kit` 的典型使用方式，再把示例代码替换为真实业务。

### 8. 第三方 SDK 接入边界已经建立

接入 analytics、feedback、pay 等第三方能力时，推荐按下面方向放置：

```text
lib/base/port/<ability>/      定义业务侧接口
lib/infra/<ability>/          实现接口并调用具体 SDK
lib/module/getIt/             注册接口和实现
lib/module/usecase/           通过接口使用能力
```

这样页面和 Cubit 不直接依赖第三方 SDK，后续替换 SDK、mock 测试或多环境切换会更简单。

## 新项目开发时怎么放代码

常见任务放置规则：

- 新页面：`lib/module/usecase`
- 新路由：`lib/module/route/RouteConfig.dart`
- 新依赖注册：`lib/module/getIt`
- 新网络 API：`lib/base/api`
- 新共享 Store：`lib/base/store`
- 新第三方 SDK 抽象：`lib/base/port`
- 新第三方 SDK 实现：`lib/infra`
- 新公共 UI：`lib/e_uikit`

## 生成项目后建议做什么

1. 修改 `pubspec.yaml` 中的 `description`。
2. 根据业务修改 `lib/base/store/settings/*.json`。
3. 清理或替换 demo 页面，保留你需要的示例。
4. 在 `lib/module/route/RouteConfig.dart` 注册真实页面。
5. 在 `lib/module/getIt/RegisterModule.dart` 注册真实依赖。
6. 每次新增功能后，更新项目内 `FEATURE_LOG.md`。

## 和 package core 的关系

`flutter_foundation_kit` 的 `lib/` 是基础库核心，不放具体业务页面、路由表或 App 专属依赖注入。生成项目里的应用结构来自 `example` 模板，业务代码应该留在生成后的项目中。
