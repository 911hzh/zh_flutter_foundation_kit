/// 基于 tag 的日志分发实现。
///
/// 一个调用可以同时命中多个 tag 对应的 logger。
import "package:flutter_foundation_kit/wcore/logger/Logger.dart";

/// 基于 tag 分发日志的 logger 实现。
///
/// 收到日志后会合并自身 tags 和本次调用传入的 tags，
/// 再把同一条日志转发给对应的真实 logger。
final class LoggerTagImpl implements LoggerProtocol {
  /// tag 到真实 logger 的映射表。
  final Map<String, LoggerProtocol> loggerImplMap;

  @override
  final List<String> tags;

  const LoggerTagImpl({required this.loggerImplMap, this.tags = const []});

  /// 基于当前 logger 创建一个带固定 tags 的视图。
  LoggerTagImpl withTags(List<String> tags) {
    return LoggerTagImpl(loggerImplMap: loggerImplMap, tags: tags);
  }

  @override
  void log(
    LogLevel level,
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  }) {
    final mergedTags = _mergeTags(this.tags, tags);
    final effectiveStackTrace = stackTrace ?? StackTrace.current;
    // 同一 logger 可能被多个 tag 命中，这里会去重后再转发。
    for (final logger in _resolveLoggers(mergedTags)) {
      logger.log(
        level,
        message,
        tags: mergedTags,
        error: error,
        stackTrace: effectiveStackTrace,
      );
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

  /// 根据 tags 找到需要接收日志的真实 logger。
  List<LoggerProtocol> _resolveLoggers(List<String> mergedTags) {
    final loggers = <LoggerProtocol>[];

    for (final tag in mergedTags) {
      final logger = loggerImplMap[tag];
      if (logger != null && !loggers.contains(logger)) {
        loggers.add(logger);
      }
    }
    return loggers;
  }

  /// 合并固定 tags 和本次调用 tags。
  List<String> _mergeTags(List<String> baseTags, List<String> callTags) {
    return [
      ...baseTags,
      for (final tag in callTags)
        if (!baseTags.contains(tag)) tag,
    ];
  }
}
