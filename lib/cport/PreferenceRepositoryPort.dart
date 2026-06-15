import 'package:flutter_foundation_kit/wcore/Repository.dart';

/// Preference 存储端口定义。
///
/// key/value 类型由每次读写的方法泛型决定。
abstract class PreferenceRepositoryPort extends Repository {
  PreferenceRepositoryPort(super.boxName);
}
