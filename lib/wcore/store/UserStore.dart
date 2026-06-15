import 'package:flutter_foundation_kit/cutil/Codable.dart';
import 'package:flutter_foundation_kit/wcore/store/StoreBase.dart';

/// 用户状态数据。
abstract class UserState extends Codable {
  /// 当前用户 id，空字符串表示未登录或未读取到用户信息。
  final String userId;

  UserState({required this.userId});
}

/// 用户 Store 抽象。
abstract class UserStore<T extends UserState> extends StoreBase<T> {
  final T initialState;

  UserStore({required T this.initialState}) : super(initialState);
}
