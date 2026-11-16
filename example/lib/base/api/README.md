# api 目录说明

`api` 用于放置当前 example 工程的网络 API 示例代码，主要展示 `flutter_foundation_kit` 中 `RestClient`、`RestClientAdapter`、`NetworkProxy` 等网络能力的接入方式。

## 当前内容

- [AppApiClient.dart](AppApiClient.dart) 聚合示例 API，当前提供 `UserApi`。
- [AppRestClientAdapter.dart](AppRestClientAdapter.dart) 从 `SettingsStore` 读取 base URL，并配置示例请求头。
- [AppNetworkProxy.dart](AppNetworkProxy.dart) 提供示例网络代理配置。
- [UserApi.dart](UserApi.dart) 演示如何通过 `RestClient` 发起请求并转换模型。
- `model/` 保存返回模型，包括 [User.dart](model/User.dart) 和 [LoginResponse.dart](model/LoginResponse.dart)。

## 和 port 的区别

`api` 当前是网络 API 示例封装，不是第三方 SDK 的 Port 抽象层。第三方 SDK 接入时，应优先在 `lib/base/port` 定义接口抽象，再在 `lib/infra` 中提供具体实现。
