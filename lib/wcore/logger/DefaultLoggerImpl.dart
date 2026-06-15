/// 默认 logger 协议实现。
///
/// 将基础库 [LogLevel] 转换为第三方 `logger` 包的等级。
import "package:flutter/foundation.dart";
import "package:flutter_foundation_kit/wcore/logger/Logger.dart";
import "package:logger/logger.dart" as logger;

/// 默认日志实现。
///
/// 内部使用 `logger: 2.4.0`，但对外只暴露 [LoggerProtocol]。
final class DefaultLoggerImpl implements LoggerProtocol {
  final logger.Logger _logger;

  @override
  List<String> get tags => const [];

  /// 创建默认 logger。
  DefaultLoggerImpl({
    LogLevel level = LogLevel.debug,
    logger.LogPrinter? printer,
    logger.LogOutput? output,
    logger.LogFilter? filter,
  }) : _logger = logger.Logger(
         level: _toLoggerLevel(level),
         filter: filter ?? _createDefaultFilter(),
         printer:
             printer ??
             logger.PrettyPrinter(
               methodCount: 0,
               errorMethodCount: 5,
               lineLength: 120,
               colors: !kReleaseMode,
               printEmojis: false,
               dateTimeFormat: logger.DateTimeFormat.onlyTimeAndSinceStart,
             ),
         output: output,
       );

  @override
  void log(
    LogLevel level,
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    // 统一在这一层完成基础库等级到 logger 包等级的转换。
    final effectiveStackTrace = stackTrace ?? StackTrace.current;
    switch (level) {
      case LogLevel.trace:
        _logger.t(message, error: error, stackTrace: effectiveStackTrace);
      case LogLevel.debug:
        _logger.d(message, error: error, stackTrace: effectiveStackTrace);
      case LogLevel.info:
        _logger.i(message, error: error, stackTrace: effectiveStackTrace);
      case LogLevel.warning:
        _logger.w(message, error: error, stackTrace: effectiveStackTrace);
      case LogLevel.error:
        _logger.e(message, error: error, stackTrace: effectiveStackTrace);
      case LogLevel.fatal:
        _logger.f(message, error: error, stackTrace: effectiveStackTrace);
      case LogLevel.off:
        break;
    }
  }

  @override
  void trace(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.trace,
      message,
      tags: tags,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  @override
  void debug(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.debug,
      message,
      tags: tags,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  @override
  void info(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.info,
      message,
      tags: tags,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  @override
  void warning(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.warning,
      message,
      tags: tags,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  @override
  void error(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.error,
      message,
      tags: tags,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  @override
  void fatal(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.fatal,
      message,
      tags: tags,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  /// 将基础库日志等级映射到 `logger` 包日志等级。
  static logger.Level _toLoggerLevel(LogLevel level) {
    return switch (level) {
      LogLevel.trace => logger.Level.trace,
      LogLevel.debug => logger.Level.debug,
      LogLevel.info => logger.Level.info,
      LogLevel.warning => logger.Level.warning,
      LogLevel.error => logger.Level.error,
      LogLevel.fatal => logger.Level.fatal,
      LogLevel.off => logger.Level.off,
    };
  }

  /// 根据当前构建模式选择默认过滤器。
  static logger.LogFilter _createDefaultFilter() {
    return kReleaseMode
        ? logger.ProductionFilter()
        : logger.DevelopmentFilter();
  }
}
