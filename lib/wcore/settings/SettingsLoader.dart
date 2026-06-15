import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_foundation_kit/wcore/settings/AppEnvironment.dart';
import 'package:flutter_foundation_kit/wcore/settings/Settings.dart';

/// Settings 加载器。
///
/// 负责串起“获取包名 -> 判断环境 -> 选择配置文件 -> 读取 JSON -> 构造 Settings”的流程。
/// 业务侧需要继承并实现包名、环境和 asset 路径解析逻辑。
abstract class SettingsLoader {
  const SettingsLoader();

  /// 获取当前应用包名。
  ///
  /// 常见实现可以来自宿主应用、平台通道、第三方壳工程或构建配置。
  String getPackageName();

  /// 根据 [packageName] 判断当前应该使用的应用环境。
  AppEnvironment getEnvironment({required String packageName});

  /// 根据 [environment] 返回对应的 settings JSON asset 路径。
  String assetPathForEnvironment(AppEnvironment environment);

  /// 从 asset 中读取 JSON Map。
  ///
  /// 默认使用 [rootBundle]，测试时可以通过 [bundle] 注入自定义资源读取器。
  Future<Map<String, dynamic>> loadAssetMap(
    String assetPath, {
    AssetBundle? bundle,
  }) {
    return (bundle ?? rootBundle)
        .loadString(assetPath)
        .then((value) => jsonDecode(value) as Map<String, dynamic>);
  }

  /// 加载并构建 Settings 实例。
  ///
  /// 配置文件只保存环境相关字段；运行时解析出的 `packageName` 和 `environment`
  /// 会在这里合并到 JSON 后再交给 [builder]。
  Future<T> getSettings<T extends SettingsBase>({
    required SettingsBuilder<T> builder,
    AssetBundle? bundle,
    Map<String, dynamic> overrides = const {},
  }) async {
    final packageName = getPackageName();
    final environment = getEnvironment(packageName: packageName);
    final assetPath = assetPathForEnvironment(environment);
    final json = await loadAssetMap(assetPath, bundle: bundle);
    return builder({
      ...json,
      ...overrides,
      "packageName": packageName,
      "environment": environment.name,
    });
  }
}
