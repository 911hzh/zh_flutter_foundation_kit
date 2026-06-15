# Logger Quick Use

## 直接使用

默认已经有 `console` logger，可以直接打印：

```dart
LoggerFactory.current.getLogger().info("app started");
```

## 配置文件输出

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

## 按 Tag 打印

```dart
LoggerFactory.current.getLogger(["api"]).info("request started");
```

一次输出到多个 tag：

```dart
LoggerFactory.current.getLogger(["api"]).info(
  "request body",
  tags: ["apiDetail"],
);
```

默认 `defaultLogTag` 是 `true`，所以上面会合并默认 `console` tag。

## 关闭默认 Tag 合并

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

## 使用自定义 Logger

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

## 替换整个工厂

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

LoggerFactory.setFactory(AppLoggerFactory());
```
