import 'dart:io';

import 'package:flutter_foundation_kit/wcore/logger/LoggerConfiguration.dart';
import 'package:flutter_foundation_kit/wcore/logger/LoggerFactory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

void main() {
  group("LoggerFactory", () {
    test("test getLogger", () {
      final logger = LoggerFactory.current.getLogger();
      expect(logger, isNotNull);
    });

    test("test loggerconfiguration", () async {
      final cacheDir = await Directory.systemTemp.createTemp(
        "logger_factory_test_",
      );
      final logDir = Directory("${cacheDir.path}/logs");
      await logDir.create(recursive: true);
      addTearDown(() async {
        // await cacheDir.delete(recursive: true);
      });
      print("logDir: ${logDir.path}");
      final testFile = File("${logDir.path}/test.log");
      final defaultFile = File("${logDir.path}/default.log");
      final advancedFile = File("${logDir.path}/advanced.log");
      final testOutput = FileOutput(file: testFile);
      final loggerConfiguration = LoggerConfiguration(
        tag: "test",
        output: testOutput,
      );
      final consoleConfig = LoggerConfiguration.console();
      final defaultConfig = LoggerConfiguration.file(
        tag: "default",
        filePath: defaultFile.path,
      );
      final advancedConfig = LoggerConfiguration.advancedFile(
        tag: "advanced",
        directoryPath: logDir.path,
        latestFileName: advancedFile.uri.pathSegments.last,
      );

      LoggerFactoryDefaultImpl.configure(
        configs: [
          loggerConfiguration,
          consoleConfig,
          defaultConfig,
          advancedConfig,
        ],
      );
      final testLogger = LoggerFactory.current.getLogger(["test"]);
      final defatLogger = LoggerFactory.current.getLogger(["default"]);
      final consoleLogger = LoggerFactory.current.getLogger(["console"]);
      final advancedLogger = LoggerFactory.current.getLogger(["advanced"]);
      testLogger.info("logger configuration test");
      testLogger.debug("logger configuration test2 debug");
      testLogger.error("logger configuration test3 error");

      defatLogger.info("default logger configuration test");
      defatLogger.debug("default logger configuration test2");
      defatLogger.error("default logger configuration test3");

      consoleLogger.info("console logger configuration test");
      consoleLogger.debug("console logger configuration test2 debug");
      consoleLogger.error("console logger configuration test3 error");
      advancedLogger.info("advanced logger configuration test");
      await testOutput.destroy();
      await defaultConfig.output?.destroy();
      await advancedConfig.output?.destroy();

      expect(testFile.existsSync(), isTrue);
      expect(defaultFile.existsSync(), isTrue);
      expect(advancedFile.existsSync(), isTrue);
    });
  });
}
