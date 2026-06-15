/// 日志协议定义。
///
/// 对外屏蔽第三方 logger 包，让业务模块只依赖基础库日志抽象。
/// 日志等级。
///
/// 这里定义一层基础库自己的枚举，避免业务代码直接依赖第三方 logger 包的类型。
enum LogLevel { trace, debug, info, warning, error, fatal, off }

/// 日志协议。
///
/// 业务模块依赖这个协议即可；具体日志实现可以使用默认的 [DefaultLogger]，
/// 也可以由调用方接入 Sentry、Crashlytics、文件日志等实现。
abstract interface class LoggerProtocol {
  /// 当前 logger 固定携带的 tags。
  List<String> get tags;

  /// 按指定等级输出日志。
  void log(
    LogLevel level,
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  });

  /// 输出 trace 等级日志。
  void trace(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  });

  /// 输出 debug 等级日志。
  void debug(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  });

  /// 输出 info 等级日志。
  void info(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  });

  /// 输出 warning 等级日志。
  void warning(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  });

  /// 输出 error 等级日志。
  void error(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  });

  /// 输出 fatal 等级日志。
  void fatal(
    Object? message, {
    List<String> tags = const [],
    Object? error,
    StackTrace? stackTrace,
  });
}
