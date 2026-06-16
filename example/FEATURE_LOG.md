# 功能记录

本文档用于记录每次新增或调整的功能。它的目标是让开发者和 AI Agent 能快速了解项目已经有哪些功能、功能入口在哪里、涉及哪些目录、如何验证。

## 使用规则

每次新增功能、调整功能入口、接入第三方 SDK、增加页面或新增共享能力后，都需要在本文档追加一条记录。

记录应包含：

- 功能说明
- 涉及目录
- 页面入口或调用入口
- 依赖注册
- 验证方式
- 备注或后续计划

## 记录模板

```md
## YYYY-MM-DD 功能名称

### 功能说明

用 1-3 句话说明本次新增或调整了什么功能。

### 涉及目录

- `lib/module/usecase/...`：页面、Cubit、VM 或模块内 Widget。
- `lib/base/port/...`：接口抽象。
- `lib/infra/...`：接口实现。
- `lib/module/getIt/...`：依赖注册。
- `lib/module/route/...`：路由注册。
- `lib/e_uikit/...`：公共 UI。

### 页面入口或调用入口

- route: `/example`
- page: `ExamplePage`
- port: `ExamplePort`

### 依赖注册

说明是否新增或调整了 GetIt / injectable 注册。

### 验证方式

说明如何验证功能可用，例如：

- 启动应用。
- 从首页进入功能页面。
- 点击按钮触发能力。
- 确认页面状态、日志、接口响应或 SDK 回调符合预期。

### 备注

记录暂未完成的部分、后续计划或注意事项。
```

## 功能列表

## 2026-06-15 示例目录归位与文档同步

### 功能说明

将 example 中依赖注册、路由和公共 UI 的说明同步到当前目录结构：依赖注册位于 `lib/module/getIt`，路由位于 `lib/module/route`，公共 UI 位于 `lib/e_uikit`。同时更新 AI 开发规则、快速上手和 lib 目录总览，避免继续引用已删除的旧顶层目录。

### 涉及目录

- `lib/module/getIt/...`：依赖注册。
- `lib/module/route/...`：路由注册。
- `lib/e_uikit/...`：公共 UI。
- `AI_DEV.md`、`lib/quick_use.md`、`lib/README.md`：目录规则和使用指引。

### 页面入口或调用入口

- route config: `lib/module/route/RouteConfig.dart`
- injection: `lib/module/getIt/Injection.dart`

### 依赖注册

本次未新增依赖注册，仅同步文档中的注册目录说明。

### 验证方式

- 搜索文档中的旧目录引用，确认活跃使用说明已指向当前目录结构。

### 备注

`example/docs/superpowers` 下的历史设计和计划记录保留原始上下文，不作为当前目录规则来源。

## 2026-06-12 网络配置拆分与 baseUrl 配置化

### 功能说明

将 example 中的 REST Client 配置从 `ApiClient.dart` 拆分出来，让 `AppRestClientAdapter` 通过 `SettingsStore` 获取 `baseUrl`，避免在 adapter 中写死地址。同时将 `AppNetworkProxy` 和 `LoginResponse` 拆成独立文件，保持一个文件一个主要 class。

### 涉及目录

- `lib/base/api/ApiClient.dart`：只保留 API 聚合类 `ApiClient`。
- `lib/base/api/AppRestClientAdapter.dart`：新增 REST Client Adapter 实现，依赖 `SettingsStore`。
- `lib/base/api/AppNetworkProxy.dart`：新增 NetworkProxy 模板实现。
- `lib/base/api/UserApi.dart`：移除内联的 `LoginResponse`。
- `lib/base/api/model/LoginResponse.dart`：新增登录响应模型。
- `lib/base/store/settings/Settings.dart`：补充 `baseUrl` 序列化。
- `lib/base/store/settings/SettingsStore.dart`：提供默认 baseUrl 初始值。
- `lib/base/store/settings/development.json`：配置 demo baseUrl。
- `lib/base/store/settings/release.json`：配置 demo baseUrl。
- `lib/module/getIt/Injection.config.dart`：由 build_runner 重新生成依赖注册。
- `AI_DEV.md`：补充一个文件一个主要 class、RestClientAdapter 和 NetworkProxy 拆分规则。

### 页面入口或调用入口

- api: `UserApi.fetchTodo`
- adapter: `AppRestClientAdapter`
- settings: `SettingsStore.state.baseUrl`

### 依赖注册

已通过 `dart run build_runner build --delete-conflicting-outputs` 重新生成 `lib/module/getIt/Injection.config.dart`。`AppRestClientAdapter` 现在注册为 `RestClientAdapter`，并注入 `SettingsStore`。

### 验证方式

- 运行 build_runner，确认 injectable 配置生成成功。
- 检查 `Injection.config.dart`，确认 `AppRestClientAdapter(settingsStore: gh<SettingsStore>())` 已生成。
- 运行 `dart analyze` 或 IDE 诊断，确认拆分后的 import 和类型引用无错误。

### 备注

`dart run build_runner build --delete-conflicting-outputs` 输出提示该参数已被忽略，但生成器执行成功并写入了新的 injectable 配置。
