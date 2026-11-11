/// 通用错误协议定义。
///
/// 用于统一业务异常、本地化错误描述和带附加数据的错误类型。
import "dart:core";

/// 带本地化文案的错误协议。
abstract class LocalizedError implements Exception {
  /// 面向用户展示的错误描述。
  String get localizedDescription;
}

/// 包含底层 [Error] 原因的运行时错误协议。
abstract class RuntimeError implements Exception {
  /// 触发当前错误的底层原因。
  Error get cause;
}

/// 带名称、文案和附加数据的通用错误。
class MetaError extends LocalizedError {
  MetaError(this.name, this.message, {this.data});

  /// 错误名称，便于日志和分类。
  String name;

  /// 错误描述。
  String message;

  /// 附加错误数据。
  dynamic data;

  @override
  String get localizedDescription => message;
}
