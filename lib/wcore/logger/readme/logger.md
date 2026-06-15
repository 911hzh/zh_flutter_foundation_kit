# Logger

`logger` 模块提供一套和业务无关的日志协议。业务侧只依赖 `LoggerFactory` 和 `LoggerProtocol`，默认实现内部适配 `logger: 2.4.0`。

## 组件职责

- `LoggerProtocol`：日志协议，定义 `trace/debug/info/warning/error/fatal`。
- `LogLevel`：基础库自己的日志等级，避免业务代码直接依赖第三方 logger 包。
- `DefaultLogger`：`package:logger` 的适配器。
- `LoggerConfiguration`：描述一个 tag 对应的 logger 配置。
- `LoggerFactory`：全局入口，持有当前 logger 工厂实例。
- `LoggerFactoryDefaultImpl`：默认工厂实现，持有配置列表，按 tag 创建 logger，并用 `WeakReference` 复用仍存活的 logger。
- `LoggerTagImpl`：一个 `LoggerProtocol` 实现，按 tags 把同一条日志分发给多个真实 logger。

## 默认实现

默认情况下，`LoggerFactory.current` 是一个空配置的 `LoggerFactoryDefaultImpl`，内置 `console` 配置：

```dart
LoggerFactory.current.getLogger().info("app started");
```

如果需要文件输出或更多 tag，使用 `LoggerFactoryDefaultImpl.configure`：

```dart
LoggerFactoryDefaultImpl.configure(
  configs: [
    LoggerConfiguration.file(
      tag: "api",
      filePath: "$logDir/flutter-request.log",
      clearOutput: true,
    ),
    LoggerConfiguration.file(
      tag: "apiDetail",
      filePath: "$logDir/flutter-api.log",
      clearOutput: true,
    ),
  ],
);
```

## Tag 规则

tag 表示日志输出目标。默认实现会从配置列表中按 tag 找到对应 logger。

```dart
LoggerFactory.current.getLogger(["api"]).info("request started");
```

`defaultLogTag` 默认为 `true`，所以调用 `getLogger(["api"])` 时会合并默认 tag：

```dart
["console", "api"]
```

如果不想自动合并默认 tag：

```dart
LoggerFactoryDefaultImpl.configure(
  configs: [
    LoggerConfiguration.file(
      tag: "api",
      filePath: "$logDir/flutter-request.log",
    ),
  ],
  defaultLogTag: false,
);
```

## 多目标输出

`LoggerTagImpl` 会合并自身 tags 和单次调用传入的 tags：

```dart
LoggerFactory.current.getLogger(["api"]).info(
  "request body",
  tags: ["apiDetail"],
);
```

最终会尝试输出到：

```dart
["console", "api", "apiDetail"]
```

其中 `console` 来自默认 tag，`api` 来自 `getLogger(["api"])`，`apiDetail` 来自本次调用参数。

## 自定义 Logger

可以把自己的 `LoggerProtocol` 实现注册到默认工厂：

```dart
LoggerFactoryDefaultImpl.configure(
  configs: [
    LoggerConfiguration(
      tag: "crash",
      logger: MyLogger(),
    ),
  ],
  defaultTags: ["crash"],
);
```

业务侧仍然只调用：

```dart
LoggerFactory.current.getLogger().error(
  "unexpected error",
  error: error,
  stackTrace: stackTrace,
);
```

## 替换工厂

如果调用方需要完全控制 logger 的创建、tag 规则或输出组合，可以实现 `LoggerFactory`：

```dart
final class AppLoggerFactory implements LoggerFactory {
  @override
  LoggerProtocol getLogger([List<String> tags = const []]) {
    return LoggerTagImpl(
      loggerImplMap: {
        "console": MyConsoleLogger(),
        "api": MyApiLogger(),
      },
      tags: tags.isEmpty ? const ["console"] : tags,
    );
  }
}
```

启动时替换：

```dart
LoggerFactory.setFactory(AppLoggerFactory());
```

业务调用不变：

```dart
LoggerFactory.current.getLogger(["api"]).info("api log");
```
