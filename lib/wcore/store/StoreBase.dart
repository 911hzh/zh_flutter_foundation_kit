// Store 状态管理基类。
//
// 基于 ValueNotifier 提供最小状态容器能力，子类负责实现数据加载、
// 标记失效和刷新逻辑。
import 'package:flutter/foundation.dart';

/// 通用 Store 抽象。
///
/// [State] 表示当前 Store 管理的状态类型。
abstract class StoreBase<State> extends ValueNotifier<State> {
  State _state;

  StoreBase(this._state) : super(_state);

  /// 当前状态快照。
  State get state => _state;

  /// 更新状态并通知监听者。
  void setState(State state) {
    _state = state;
    value = state;
  }

  /// 获取当前状态，必要时由子类从外部数据源加载。
  Future<State> get();

  /// 标记当前状态失效。
  void dirty();

  /// 强制刷新当前状态。
  void renew();
}
