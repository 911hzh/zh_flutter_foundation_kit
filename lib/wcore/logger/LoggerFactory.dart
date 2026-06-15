/// Logger 工厂入口。
///
/// 维护全局 logger 工厂，并向业务侧提供按 tag 获取 logger 的能力。
import "package:flutter_foundation_kit/wcore/logger/DefaultLoggerImpl.dart";
import "package:flutter_foundation_kit/wcore/logger/Logger.dart";
import "package:flutter_foundation_kit/wcore/logger/LoggerConfiguration.dart";
import "package:flutter_foundation_kit/wcore/logger/LoggerTagImpl.dart";

part "LoggerFactoryDefaultImpl.dart";

/// Logger 工厂。
///
/// 对外提供轻量静态入口；调用方可以通过 [setFactory] 替换具体实现。
abstract class LoggerFactory {
  static LoggerFactory _current = LoggerFactoryDefaultImpl();

  /// 替换当前全局 logger 工厂。
  static void setFactory(LoggerFactory factory) {
    _current = factory;
  }

  /// 当前全局 logger 工厂。
  static LoggerFactory get current => _current;

  /// 按 tags 获取 logger。
  LoggerProtocol getLogger([List<String> tags = const []]);
}
