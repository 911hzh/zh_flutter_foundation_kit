# Settings Quick Use

`settings` 模块用于管理应用启动配置。基础库只定义通用协议和加载流程，业务项目负责定义具体字段、包名来源和环境映射规则。

## 1. 定义配置文件

配置文件只保存当前环境相关字段。`packageName` 和 `environment` 通常来自运行时，由 `SettingsLoader` 合并进去。

例如 `assets/settings/development.json`：

```json
{
  "baseUrl": "https://dev-api.example.com",
  "instabugToken": "development-instabug-token"
}
```

例如 `assets/settings/release.json`：

```json
{
  "baseUrl": "https://api.example.com",
  "instabugToken": "release-instabug-token"
}
```

在 `pubspec.yaml` 中声明 asset：

```yaml
flutter:
  assets:
    - assets/settings/development.json
    - assets/settings/release.json
```

## 2. 定义 AppSettings

业务项目需要定义自己的 Settings 类型，并实现 `SettingsBase`。

```dart
import "package:flutter_foundation_kit/flutter_foundation_kit.dart";

final class AppSettings implements SettingsBase {
  @override
  final String packageName;

  @override
  final AppEnvironment environment;

  final String baseUrl;
  final String instabugToken;

  const AppSettings({
    required this.packageName,
    required this.environment,
    required this.baseUrl,
    required this.instabugToken,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      packageName: json["packageName"] as String,
      environment: _environmentFromJson(json["environment"] as String),
      baseUrl: json["baseUrl"] as String,
      instabugToken: json["instabugToken"] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "packageName": packageName,
      "environment": environment.name,
      "baseUrl": baseUrl,
      "instabugToken": instabugToken,
    };
  }

  static AppEnvironment _environmentFromJson(String value) {
    return switch (value) {
      "development" => AppEnvironment.development,
      "release" || "production" => AppEnvironment.production,
      "test" => AppEnvironment.test,
      _ => AppEnvironment(value),
    };
  }
}
```

`AppEnvironment` 是 value object，不是 enum。业务侧可以使用内置环境，也可以创建自己的环境：

```dart
const staging = AppEnvironment("staging");
```

## 3. 定义 SettingsLoader

继承 `SettingsLoader`，实现包名来源、环境判断和配置文件路径选择。

```dart
final class AppSettingsLoader extends SettingsLoader {
  const AppSettingsLoader();

  @override
  String getPackageName() {
    // 真实项目里可以来自平台通道、宿主应用、第三方壳工程或构建配置。
    return "com.example.app.dev";
  }

  @override
  AppEnvironment getEnvironment({required String packageName}) {
    return switch (packageName) {
      "com.example.app.dev" => AppEnvironment.development,
      "com.example.app" => AppEnvironment.production,
      _ => throw ArgumentError.value(packageName, "packageName", "Unsupported package name."),
    };
  }

  @override
  String assetPathForEnvironment(AppEnvironment environment) {
    return switch (environment.name) {
      "development" => "assets/settings/development.json",
      "production" => "assets/settings/release.json",
      _ => throw ArgumentError.value(environment, "environment", "No settings asset."),
    };
  }
}
```

`SettingsLoader.getSettings()` 会自动完成：

- 获取包名
- 根据包名判断环境
- 根据环境选择配置文件
- 读取 JSON
- 合并 `packageName` 和 `environment`
- 调用 `builder` 构建业务 Settings

## 4. 初始化 Settings

通常在应用启动阶段初始化一次。

```dart
late final AppSettings appSettings;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appSettings = await const AppSettingsLoader().getSettings(
    builder: AppSettings.fromJson,
  );

  runApp(const App());
}
```

## 5. 读取当前配置

初始化完成后，业务侧读取自己持有的 Settings 实例。

```dart
print(appSettings.packageName);
print(appSettings.environment.name);
print(appSettings.baseUrl);
print(appSettings.instabugToken);
```

## 6. 临时覆盖配置

`SettingsLoader.getSettings()` 支持 `overrides`，适合测试或开发时临时覆盖配置。

```dart
final settings = await const AppSettingsLoader().getSettings(
  builder: AppSettings.fromJson,
  overrides: {
    "baseUrl": "https://override.example.com",
  },
);
```

## 推荐用法

- `SettingsBase` 只放应用级基础配置，不放业务状态。
- 配置文件只保存环境相关字段，包名和环境由运行时解析后注入。
- `SettingsLoader` 负责包名、环境和 asset 路径规则。
- 业务项目自行决定如何持有最终的 Settings 实例，例如全局单例、依赖注入或状态管理容器。
