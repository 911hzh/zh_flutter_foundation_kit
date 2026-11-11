import 'package:flutter_foundation_kit/cutil/Codable.dart';

/// 应用运行环境。
///
/// 使用 value object 代替 enum，避免业务侧被 Dart enum 不可继承的限制绑死。
///
class AppEnvironment extends Codable {
  /// 环境名称，用于 JSON 序列化和配置文件选择。
  final String name;

  const AppEnvironment(this.name);

  /// 开发环境。
  static const development = AppEnvironment("development");

  /// 正式环境。
  static const production = AppEnvironment("production");

  /// 测试环境。
  static const test = AppEnvironment("test");

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppEnvironment && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;

  @override
  Map<String, dynamic> toJson() => {"name": name};

  static AppEnvironment fromJson(Map<String, dynamic> json) =>
      AppEnvironment(json["name"] as String);
}
