# lib 目录说明

`lib` 是 `flutter_foundation_kit` package 的源码目录。这里的代码用于提供可发布、可复用的 Flutter 基础能力，业务项目应优先通过 `flutter_foundation_kit.dart` 统一导入。

## 顶层入口

### `flutter_foundation_kit.dart`

统一导出入口。业务项目优先导入这个文件，避免直接依赖 package 内部目录结构。

当前导出的能力包括：

- REST Client 抽象和默认实现。
- REST Response 和错误模型。
- JSON、懒加载、轮询、错误等工具。
- Logger 协议、配置和默认实现。
- Settings、Store、Repository 等基础抽象。

## `api`

`api` 放对外网络请求协议和统一响应模型。

### `api/RestClient.dart`

REST 请求客户端协议。定义 `request`、`get`、`post`、`put`、`patch`、`delete` 等基础请求方法。

### `api/RestClientBase.dart`

基于 Dio 的 REST 客户端基础实现。统一封装请求超时、快捷 HTTP 方法、响应解析和 Dio 错误转换。

### `api/RestResponse.dart`

统一 REST 响应模型。提供状态码、响应头、响应体，并提供 `toModel`、`toMap`、`extractModel`、子线程解析等转换扩展。

### `api/RestRequestError.dart`

统一网络请求异常模型。继承 `RestResponse`，保留服务端响应信息，并支持通过 handler 自定义本地化错误文案。

## `wcore`

`wcore` 放基础库核心能力，包括网络默认实现、日志、配置和 Store。

### `wcore/apiImpl/RestClientImpl.dart`

默认 REST 客户端实现。基于 Dio，接收 `RestClientAdapter` 和 `NetworkProxy`，负责配置 baseUrl、请求拦截、错误回调和可选代理适配。

### `wcore/apiImpl/RestClientAdapter.dart`

REST 客户端适配器。业务项目继承它来自定义 baseUrl、公共 headers、请求前处理和错误处理。

### `wcore/apiImpl/NetworkProxy.dart`

网络代理配置抽象。维护当前代理地址，支持代理变化通知，并将普通 host:port 转换为 Dio/HttpClient 可识别的代理规则。

### `wcore/apiImpl/ApiLocalInterceptor.dart`

网络请求本地拦截相关能力。用于后续扩展本地 mock、请求改写或调试拦截。

### `wcore/apiImpl/ApiClientLogger.dart`

网络请求日志辅助能力。用于围绕 API 请求输出调试信息。

### `wcore/logger/Logger.dart`

日志协议和日志等级定义。业务项目依赖 `LoggerProtocol`，避免直接绑定第三方 logger 包。

### `wcore/logger/LoggerFactory.dart`

全局 Logger 工厂入口。支持通过 `LoggerFactory.setFactory` 替换默认日志工厂。

### `wcore/logger/LoggerFactoryDefaultImpl.dart`

默认 Logger 工厂实现。根据 tag 返回对应 logger。

### `wcore/logger/LoggerConfiguration.dart`

日志配置对象。支持 console、file、advancedFile 输出，并可配置日志等级、printer、filter、output。

### `wcore/logger/DefaultLoggerImpl.dart`

默认日志实现。内部使用 `logger` 包，但对外只暴露基础库的 `LoggerProtocol`。

### `wcore/logger/LoggerTagImpl.dart`

带固定 tag 的 Logger 包装实现。适合按业务模块或功能模块区分日志来源。

### `wcore/logger/LoggerPrettyPrinter.dart`

默认日志格式化器。负责控制日志输出格式。

### `wcore/settings/AppEnvironment.dart`

应用运行环境值对象。内置 `development`、`production`、`test`，业务项目也可以创建自定义环境。

### `wcore/settings/Settings.dart`

应用配置最小协议。业务项目继承 `SettingsBase` 后可以扩展自己的配置字段。

### `wcore/settings/SettingsLoader.dart`

配置加载器抽象。负责串起包名获取、环境判断、asset 路径选择、JSON 读取和 Settings 构造流程。

### `wcore/settings/quick_use.md`

Settings 能力的快速使用说明。

### `wcore/store/StoreBase.dart`

Store 状态管理基类。基于 `ValueNotifier` 提供轻量状态容器能力，子类实现 `get`、`dirty`、`renew`。

### `wcore/store/AuthStore.dart`

登录态 Store 抽象。定义 `AuthState`、token、userId、登录和退出登录能力。

### `wcore/store/UserStore.dart`

用户 Store 抽象。定义用户状态最小结构，供业务项目扩展具体用户信息。

### `wcore/Repository.dart`

通用仓储协议。定义按 key 读写 value 和删除数据的最小接口。

## `cport`

`cport` 放基础能力端口协议。端口表示业务或基础库希望依赖的抽象，不直接绑定具体插件。

### `cport/KeychainPort.dart`

安全存储端口。继承 `Repository`，用于抽象 Keychain / Keystore 等安全存储能力。

### `cport/PreferenceRepositoryPort.dart`

偏好设置存储端口。继承 `Repository`，用于抽象 SharedPreferences 一类普通本地存储能力。

## `infra`

`infra` 放端口协议的默认基础设施实现，可以依赖第三方插件或平台能力。

### `infra/KeyChainImpl.dart`

基于 `flutter_keychain` 的安全存储实现。用于保存 token 等敏感数据。

### `infra/PreferenceRepositoryImpl.dart`

基于 `shared_preferences` 的偏好设置实现。支持 String、int、bool、double、List<String>、Map、List 和 `Codable` 类型。

## `port`

`port` 是历史端口目录，当前包含 `KeychainPort.dart`。后续建议统一使用 `cport` 存放基础能力端口，避免端口目录分散。

### `port/KeychainPort.dart`

Keychain 端口相关文件。与 `cport/KeychainPort.dart` 职责相近，后续可以视兼容性逐步收敛。

## `cutil`

`cutil` 放通用工具类和扩展，要求尽量无业务依赖。

### `cutil/Codable.dart`

JSON 编解码协议。模型类可以继承它并实现 `toJson` / `fromJson`。

### `cutil/JsonUtil.dart`

JSON 工具类。支持 stringify、parse、parseList、pretty、clone，以及 isolate 异步版本。

### `cutil/Lazyload.dart`

异步懒加载缓存工具。首次访问执行任务并缓存结果，支持 dirty、renew、cancel。

### `cutil/Polling.dart`

轮询任务工具。基于 `Lazyload` 执行异步任务，并按固定间隔重复触发。

### `cutil/Error.dart`

通用错误协议和错误模型。包含 `LocalizedError`、`RuntimeError`、`MetaError`。

### `cutil/Generator.dart`

简单递增 ID 生成器。

### `cutil/ListExtention.dart`

List 相关扩展能力。

### `cutil/extension/BuildContextExtension.dart`

BuildContext 扩展。当前提供读取当前 context 渲染尺寸的 `renderSize`。

## 开发约定

- 对外能力优先从 `flutter_foundation_kit.dart` 导出。
- 抽象协议放 `api`、`wcore` 或 `cport`，具体插件实现放 `infra`。
- 工具类放 `cutil`，不要引入业务项目概念。
- 新增核心能力时，同步更新 package 根 `README.md` 和本文件。
- 如果新增能力有较复杂用法，建议在对应目录下新增 `quick_use.md`。
