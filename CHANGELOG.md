# 更新日志

## 0.9.0

- 整理基础库发布配置，新增根目录 analyzer/formatter 配置。
- 扩展 CI 覆盖范围，增加生成器测试和 example 模板 analyze/test。
- 清理 example 模板依赖，移除未使用的 `flutter_riverpod`。
- 同步模板生成器默认依赖版本为 `flutter_foundation_kit: ^0.9.0`。
- 补充 `AGENTS.md` 发布版本同步规则，降低版本号漂移风险。
- 修正 logger formatter 废弃 API 使用，并清理 analyzer 细节。

## 0.0.4

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
