/// 基于 `flutter_keychain` 的安全存储实现。
///
/// 负责把基础库定义的 [KeychainPort] 适配到平台 Keychain / Keystore 插件。
import 'dart:convert';

import 'package:flutter_foundation_kit/cport/KeychainPort.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

/// 默认 Keychain 适配器。
class KeyChainImpl extends KeychainPort {
  KeyChainImpl() : super("keychain");

  @override
  Future<void> setValue<K, V>(K key, V? value) async {
    // 插件写入接口不接受 null，这里将 null 约定为删除该 key。
    if (value == null) {
      return FlutterKeychain.remove(key: key.toString());
    }
    return FlutterKeychain.put(key: key.toString(), value: jsonEncode(value));
  }

  @override
  Future<V?> getValue<K, V>(K key) async {
    final value = await FlutterKeychain.get(key: key.toString());
    if (value == null) {
      return null;
    }
    return jsonDecode(value) as V;
  }

  @override
  Future<void> delete<K>(K key) async {
    return FlutterKeychain.remove(key: key.toString());
  }
}
