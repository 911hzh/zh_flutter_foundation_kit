# module 目录说明

`module` 用于组织业务模块和 demo 页面。当前 example 工程主要在这里展示 `flutter_foundation_kit` 的使用方式，每个 demo 主题可以包含 Page、Cubit、VM 和局部 Widget。

## 当前内容

- `demos/pages/home`：demo 首页和入口列表。
- `demos/pages/login`、`logout`：登录和退出登录示例。
- `demos/pages/apiImpl`：REST Client 调用示例。
- `demos/pages/store`、`userStore`、`settings`：Store 和设置能力示例。
- `demos/pages/logger`、`cutil`：日志和工具能力示例。

## 使用约定

模块目录主要负责页面展示、交互入口和状态编排。需要第三方 SDK 能力时，模块应依赖 `base/port` 中的接口，并通过 `getIt` 获取实现，避免直接调用 `infra` 或具体 SDK。
