import 'package:flutter_foundation_kit/wcore/settings/AppEnvironment.dart';
import 'package:flutter_foundation_kit/wcore/settings/Settings.dart';
import 'package:flutter_foundation_kit/wcore/settings/SettingsLoader.dart';

final class AppSettings implements SettingsBase {
  @override
  final String packageName;

  @override
  final AppEnvironment environment;

  final String baseUrl;
  final String instabugToken;

  AppSettings({
    required this.packageName,
    required this.environment,
    required this.baseUrl,
    required this.instabugToken,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      packageName: json["packageName"] as String,
      environment: environmentFromJson(json["environment"] as String),
      baseUrl: json["baseUrl"] as String,
      instabugToken: json["instabugToken"] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "packageName": packageName,
    "environment": environment.name,
    "baseUrl": baseUrl,
    "instabugToken": instabugToken,
  };
}

final class TestSettingsLoader extends SettingsLoader {
  static const developmentPackageName =
      "com.flutter.foundation.kit.development";
  static const releasePackageName = "com.flutter.foundation.kit";

  final String packageName;

  const TestSettingsLoader({required this.packageName});

  @override
  String getPackageName() => packageName;

  @override
  AppEnvironment getEnvironment({required String packageName}) {
    return switch (packageName) {
      developmentPackageName => AppEnvironment.development,
      releasePackageName => AppEnvironment.production,
      _ =>
        throw ArgumentError.value(
          packageName,
          "packageName",
          "Unsupported package name.",
        ),
    };
  }

  @override
  String assetPathForEnvironment(AppEnvironment environment) {
    return switch (environment.name) {
      "development" => "test/wcore/settings/development.json",
      "production" => "test/wcore/settings/release.json",
      _ =>
        throw ArgumentError.value(
          environment,
          "environment",
          "No settings asset for test.",
        ),
    };
  }
}

AppEnvironment environmentFromJson(String value) {
  return switch (value) {
    "development" => AppEnvironment.development,
    "release" || "production" => AppEnvironment.production,
    "test" => AppEnvironment.test,
    _ =>
      throw ArgumentError.value(
        value,
        "environment",
        "Unsupported app environment.",
      ),
  };
}
