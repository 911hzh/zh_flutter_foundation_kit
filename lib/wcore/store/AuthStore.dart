/// 登录态 Store 定义。
///
/// 负责从安全存储读取 token，并将登录状态暴露为可监听的 [AuthState]。
import 'package:flutter_foundation_kit/cutil/Codable.dart';
import 'package:flutter_foundation_kit/wcore/Repository.dart';
import 'package:flutter_foundation_kit/wcore/store/StoreBase.dart';

/// 登录态数据。
abstract class AuthState extends Codable {
  /// 当前登录 token，空字符串表示未登录或未读取到 token。
  final String token;

  /// 当前登录用户 id，空字符串表示未登录或未读取到用户。
  final String userId;

  AuthState({required this.token, required this.userId});
}

/// 登录态 Store 抽象。
abstract class AuthStore<T extends AuthState> extends StoreBase<T> {
  /// 用于持久化 token 的安全存储端口。
  final Repository keychainPort;
  final T initialState;

  AuthStore({required this.keychainPort, required T this.initialState})
    : super(initialState) {
    // 加载的时候如果能拿到uerId ，那么就可以进行存储和读取
  }

  Future<T> loginWithToken(String token, {required String userId});
  Future<void> logout();
}
