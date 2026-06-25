# 更新日志

## 0.0.3

- 示例工程接入 `go_router`，统一登录、退出和功能页跳转方式。
- 修正示例工程的依赖注入配置，区分认证和用户偏好存储仓库实例。
- 更新示例工程依赖，添加 `go_router` 并同步 lockfile。
- 补充 REST 客户端绝对 URL 请求测试，验证完整 `http/https` 地址不会拼接 `baseUrl`。

## 0.0.2

- 添加 pub.dev 发布所需的仓库元数据。
- 放宽 `logger` 和 `synchronized` 的依赖版本约束，提升下游项目兼容性。
- 添加 package 发布相关文件，并忽略生成的 `build/` 输出目录。
- 更新根 package 的 CI 分析和测试流程。

## 0.0.1

- 初始发布 `flutter_foundation_kit`。
- 添加可复用的基础模块，覆盖 REST 请求、日志、配置、Store、本地持久化和通用工具。
- 添加 JSON 工具、懒加载、轮询、存储适配、REST 响应、配置、Store 和 logger 行为测试。
