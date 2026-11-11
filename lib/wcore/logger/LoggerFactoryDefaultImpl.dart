/// LoggerFactory 的默认实现文件。
///
/// 该文件作为 `LoggerFactory.dart` 的 part，不单独对外导入。
part of "LoggerFactory.dart";

/// 默认 logger 工厂实现。
///
/// 负责把 [LoggerConfiguration] 转成 tag 映射，并按 tags 创建 logger。
final class LoggerFactoryDefaultImpl implements LoggerFactory {
  final List<LoggerConfiguration> _configs;
  final Map<String, WeakReference<LoggerProtocol>> _loggerImplMap = {};
  final List<String> _defaultTags;
  final bool defaultLogTag;

  /// 创建默认 logger 工厂。
  LoggerFactoryDefaultImpl({
    List<LoggerConfiguration> configs = const [],
    List<String> defaultTags = const ["console"],
    this.defaultLogTag = true,
  }) : _configs = List.unmodifiable([
         LoggerConfiguration.console(),
         ...configs,
       ]),
       _defaultTags = List.unmodifiable(defaultTags);

  /// 当前 logger 配置列表。
  List<LoggerConfiguration> get configs => _configs;

  /// 根据配置初始化默认 logger 工厂。
  static void configure({
    List<LoggerConfiguration> configs = const [],
    List<String> defaultTags = const ["console"],
    bool defaultLogTag = true,
  }) {
    LoggerFactory.setFactory(
      LoggerFactoryDefaultImpl(
        configs: configs,
        defaultTags: defaultTags,
        defaultLogTag: defaultLogTag,
      ),
    );
  }

  @override
  LoggerProtocol getLogger([List<String> tags = const []]) {
    // 默认 tag 与调用方 tag 合并后，创建带 tag 分发能力的 logger。
    final activeTags =
        defaultLogTag
            ? _mergeTags(_defaultTags, tags)
            : List<String>.unmodifiable(tags);
    return LoggerTagImpl(
      loggerImplMap: _createLoggerMap(activeTags),
      tags: activeTags,
    );
  }

  /// 根据 tags 生成实际 logger 映射表。
  Map<String, LoggerProtocol> _createLoggerMap(List<String> tags) {
    final loggerMap = <String, LoggerProtocol>{};
    for (final tag in tags) {
      final logger = _resolveLogger(tag);
      if (logger != null) {
        loggerMap[tag] = logger;
      }
    }
    return loggerMap;
  }

  /// 合并默认 tags 和调用方 tags，并去除重复项。
  List<String> _mergeTags(List<String> baseTags, List<String> tags) {
    return List<String>.unmodifiable([
      ...baseTags,
      for (final tag in tags)
        if (!baseTags.contains(tag)) tag,
    ]);
  }

  /// 按 tag 获取或创建 logger 实例。
  LoggerProtocol? _resolveLogger(String tag) {
    final cachedLogger = _loggerImplMap[tag]?.target;
    if (cachedLogger != null) {
      return cachedLogger;
    }

    final configuration = _configurationForTag(tag);
    if (configuration == null) {
      return null;
    }

    final logger = _createLogger(configuration);
    _loggerImplMap[tag] = WeakReference(logger);
    return logger;
  }

  /// 查找指定 tag 对应的配置。
  LoggerConfiguration? _configurationForTag(String tag) {
    for (final config in _configs) {
      if (config.tag == tag) {
        return config;
      }
    }
    return null;
  }
}

/// 根据配置创建 logger 实例。
LoggerProtocol _createLogger(LoggerConfiguration configuration) {
  return configuration.logger ??
      DefaultLoggerImpl(
        level: configuration.level,
        output: configuration.output,
        printer: configuration.printer,
        filter: configuration.filter,
      );
}
