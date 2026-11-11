/// Keychain 安全存储端口定义。
///
/// 上层业务依赖该端口，不直接依赖具体平台插件实现。
import 'package:flutter_foundation_kit/wcore/Repository.dart';

/// 安全存储协议，key/value 类型由每次读写的方法泛型决定。
abstract class KeychainPort extends Repository {
  KeychainPort(super.boxName);
}
