/// Logger 初始化配置。
///
/// 用于描述每个日志 tag 对应的输出方式、过滤器和等级。
import "dart:io";

import "package:flutter_foundation_kit/wcore/logger/Logger.dart";
import "package:flutter_foundation_kit/wcore/logger/LoggerPrettyPrinter.dart";
import "package:logger/logger.dart" as logg;

/// Logger 注册配置。
///
/// 一个配置对应一个 tag 和一个具体 logger 实现。
final class LoggerConfiguration {
  /// 配置对应的日志 tag。
  final String tag;

  /// 自定义 logger 实现；为空时使用默认 logger 包装实现。
  final LoggerProtocol? logger;

  /// 最低输出等级。
  final LogLevel level;

  /// logger 包输出目标。
  final logg.LogOutput? output;

  /// logger 包打印格式。
  logg.LogPrinter? printer;

  /// logger 包过滤器。
  logg.LogFilter? filter;

  LoggerConfiguration({
    required this.tag,
    this.logger,
    this.level = LogLevel.info,
    this.output,
    this.printer,
    this.filter,
  }) {
    printer = printer ?? LoggerPrettyPrinter();
  }

  /// 使用 `logger` 包默认控制台输出。
  LoggerConfiguration.console({
    this.tag = "console",
    this.level = LogLevel.debug,
    logg.LogPrinter? printer,
    this.filter,
  }) : logger = null,
       printer = printer ?? LoggerPrettyPrinter(),
       output = null;

  /// 输出到一个文件。
  LoggerConfiguration.file({
    required this.tag,
    this.level = LogLevel.info,
    required String filePath,
    bool clearOutput = false,
    logg.LogPrinter? printer,
    this.filter,
  }) : logger = null,
       printer = printer ?? LoggerPrettyPrinter(),
       output = logg.FileOutput(
         file: File(filePath),
         overrideExisting: clearOutput,
       );

  /// 输出到文件目录，并支持按大小轮转日志文件。
  ///
  /// 未传入 [fileNameFormatter] 时，归档日志会基于 [latestFileName] 命名。
  /// 例如 `app.log` 会轮转为 `app-2026-0523-1429-123.log`。
  LoggerConfiguration.advancedFile({
    required this.tag,
    this.level = LogLevel.info,
    required String directoryPath,
    bool clearOutput = false,
    logg.LogPrinter? printer,
    this.filter,
    List<logg.Level>? writeImmediately,
    Duration maxDelay = const Duration(seconds: 2),
    int maxBufferSize = 2000,
    int maxFileSizeKB = 1024,
    String latestFileName = "latest.log",
    String Function(DateTime timestamp)? fileNameFormatter,
    int? maxRotatedFilesCount,
    Comparator<File>? fileSorter,
  }) : logger = null,
       printer = printer ?? LoggerPrettyPrinter(),
       output = logg.AdvancedFileOutput(
         path: directoryPath,
         overrideExisting: clearOutput,
         writeImmediately: writeImmediately,
         maxDelay: maxDelay,
         maxBufferSize: maxBufferSize,
         maxFileSizeKB: maxFileSizeKB,
         latestFileName: latestFileName,
         fileNameFormatter:
             fileNameFormatter ??
             _createRotatedFileNameFormatter(latestFileName),
         maxRotatedFilesCount: maxRotatedFilesCount,
         fileSorter: fileSorter,
       );

  static String Function(DateTime timestamp) _createRotatedFileNameFormatter(
    String latestFileName,
  ) {
    final extensionIndex = latestFileName.lastIndexOf(".");
    final hasExtension =
        extensionIndex > 0 && extensionIndex < latestFileName.length - 1;
    final name =
        hasExtension
            ? latestFileName.substring(0, extensionIndex)
            : latestFileName;
    final extension =
        hasExtension ? latestFileName.substring(extensionIndex) : ".log";

    return (time) {
      final date =
          "${time.year}-${_digits(time.month, 2)}${_digits(time.day, 2)}";
      final minute = "${_digits(time.hour, 2)}${_digits(time.minute, 2)}";
      final millisecond = _digits(time.millisecond, 3);
      return "$name-$date-$minute-$millisecond$extension";
    };
  }

  static String _digits(int value, int length) =>
      value.toString().padLeft(length, "0");
}
