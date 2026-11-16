# route 目录说明

`route` 用于维护应用路由和全局导航能力。模块页面如果需要被首页或其他入口打开，需要在这里注册路由。

## 当前内容

- [RouteConfig.dart](RouteConfig.dart) 根据初始路径创建 `GoRouter`，并通过 `GoRoute` 注册各示例页面。
- [GlobalNavigatorKey.dart](GlobalNavigatorKey.dart) 定义 `globalNavigatorKey`，当前由 `App.dart` 传给 `MaterialApp.router` 的 `key`。

## 使用约定

新增可访问页面时，需要同步更新路由配置，并确保模块首页列表中的 route 与这里保持一致。路由层只负责页面入口，不承载具体业务逻辑。
