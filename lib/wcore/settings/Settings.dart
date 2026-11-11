/// 应用配置协议定义。
///
/// 基础库只定义最小协议，具体配置字段由业务项目自行扩展。
import "package:flutter_foundation_kit/cutil/Codable.dart";
import "package:flutter_foundation_kit/wcore/settings/AppEnvironment.dart";

/// 所有 Settings 实现类需要遵守的最小协议。
///
/// 调用方可以在自己的 Settings 类中继续扩展业务字段，例如 baseUrl、语言、
/// mock 开关等；基础库只关心包名、环境和 JSON 转换能力。
abstract class SettingsBase extends Codable {
  /// 应用包名。
  String get packageName;

  /// 当前应用运行环境。
  AppEnvironment get environment;
}

/// 将 JSON Map 转成具体 Settings 实例的构造函数类型。
///
/// Dart 的泛型类型参数不能直接调用静态方法，例如 `T.fromJson()`，
/// 所以这里由调用方显式传入 `AppSettings.fromJson`。
typedef SettingsBuilder<T extends SettingsBase> =
    T Function(Map<String, dynamic> json);
