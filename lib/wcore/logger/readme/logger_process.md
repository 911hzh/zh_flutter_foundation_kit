# Logger Process

## 结构图

```mermaid
flowchart TD
  LoggerFactory["LoggerFactory current"]
  LoggerFactoryDefaultImpl["LoggerFactoryDefaultImpl"]
  LoggerConfiguration["LoggerConfiguration list"]
  LoggerTagImpl["LoggerTagImpl"]
  LoggerProtocol["LoggerProtocol"]
  DefaultLogger["DefaultLogger"]
  PackageLogger["package logger"]
  CustomFactory["Custom LoggerFactory"]
  CustomLogger["Custom LoggerProtocol"]

  LoggerFactory -->|"default current"| LoggerFactoryDefaultImpl
  LoggerFactory -->|"setFactory"| CustomFactory
  LoggerFactoryDefaultImpl --> LoggerConfiguration
  LoggerFactoryDefaultImpl -->|"getLogger"| LoggerTagImpl
  LoggerTagImpl -->|"dispatch by tag"| LoggerProtocol
  DefaultLogger -->|"implements"| LoggerProtocol
  CustomLogger -->|"implements"| LoggerProtocol
  DefaultLogger --> PackageLogger
```

## 初始化流程

```mermaid
sequenceDiagram
  participant App
  participant DefaultFactory as LoggerFactoryDefaultImpl
  participant Factory as LoggerFactory

  App->>DefaultFactory: configure(configs, defaultTags, defaultLogTag)
  DefaultFactory->>DefaultFactory: create instance with configs
  DefaultFactory->>Factory: setFactory(instance)
```

不调用 `configure` 时，`LoggerFactory.current` 已经默认指向一个空配置的 `LoggerFactoryDefaultImpl`，它内置 `console` 配置。

## 获取 Logger

```mermaid
sequenceDiagram
  participant App
  participant Factory as LoggerFactory
  participant DefaultFactory as LoggerFactoryDefaultImpl
  participant TagLogger as LoggerTagImpl

  App->>Factory: current
  Factory-->>App: DefaultFactory
  App->>DefaultFactory: getLogger(["api"])
  DefaultFactory->>DefaultFactory: merge defaultTags when enabled
  DefaultFactory->>DefaultFactory: resolve loggers from WeakReference
  DefaultFactory-->>App: TagLogger
```

`LoggerFactoryDefaultImpl.getLogger` 返回的是 `LoggerTagImpl`，不是某一个真实 logger。`LoggerTagImpl` 会在真正打印时按 tag 分发。

## 弱引用复用

```mermaid
sequenceDiagram
  participant DefaultFactory as LoggerFactoryDefaultImpl
  participant WeakMap as WeakReference map
  participant Configs as LoggerConfiguration list
  participant Logger as LoggerProtocol

  DefaultFactory->>WeakMap: read tag target
  alt target alive
    WeakMap-->>DefaultFactory: Logger
  else target missing
    DefaultFactory->>Configs: find configuration by tag
    DefaultFactory->>Logger: create logger
    DefaultFactory->>WeakMap: save WeakReference(logger)
  end
```

弱引用 map 只保存已经创建过的 logger。取出来的 `.target` 是强引用对象本身，本次返回的 `LoggerTagImpl` 会强持有本次需要使用的 logger map。

## Tag 合并

```mermaid
sequenceDiagram
  participant App
  participant FactoryLogger as LoggerTagImpl
  participant ApiLogger
  participant ApiDetailLogger

  App->>FactoryLogger: info("request", tags: ["apiDetail"])
  FactoryLogger->>FactoryLogger: merge own tags and call tags
  FactoryLogger->>ApiLogger: info("request")
  FactoryLogger->>ApiDetailLogger: info("request")
```

例如：

```dart
LoggerFactory.current.getLogger(["api"]).info(
  "request body",
  tags: ["apiDetail"],
);
```

当 `defaultLogTag` 为 `true` 且默认 tags 是 `["console"]` 时，最终会尝试输出到：

```dart
["console", "api", "apiDetail"]
```

## 替换工厂

```mermaid
flowchart TD
  AppFactory["AppLoggerFactory implements LoggerFactory"]
  Factory["LoggerFactory"]
  Logger["LoggerProtocol"]

  Factory -->|"setFactory"| AppFactory
  Factory -->|"current.getLogger"| AppFactory
  AppFactory --> Logger
```

调用方可以实现自己的 `LoggerFactory`，然后通过 `LoggerFactory.setFactory` 替换默认工厂。业务调用仍然只依赖 `LoggerFactory.current.getLogger()`。
