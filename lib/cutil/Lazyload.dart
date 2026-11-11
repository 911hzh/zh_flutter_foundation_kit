/// 异步懒加载缓存工具。
///
/// 首次访问时执行异步任务并缓存结果，后续访问复用缓存。
import "package:flutter_foundation_kit/cutil/Error.dart";
import "package:synchronized/synchronized.dart";
import "package:async/async.dart";

/// 懒加载任务函数。
typedef LazyloadHandler<T> = Future<T> Function();

/// 包装任务执行结果，便于区分取消、成功和失败。
class _HandlerResult<T> {
  final T value;
  final Object? error;

  const _HandlerResult(this.value, this.error);
}

/// 异步懒加载缓存器。
class Lazyload<T> {
  final Lock _lock = Lock();
  late final LazyloadHandler<T> _handler;

  /// 当前已缓存的值。
  T? get value {
    return _value;
  }

  T? _value;
  CancelableOperation<_HandlerResult<T>>? _cancelableOperation;

  Lazyload(LazyloadHandler<T> handler) {
    _handler = handler;
  }

  /// 清空缓存，下次 [get] 会重新执行任务。
  dirty() {
    _value = null;
  }

  /// 强制重新执行任务并更新缓存。
  Future<T> renew() async {
    _value = await _handler();
    return _value as T;
  }

  /// 获取缓存值；无缓存时只允许一个任务实际执行。
  Future<T> get() async {
    if (_value != null) return _value as T;
    return await _lock.synchronized(() async {
      if (_value != null) return _value as T;

      Future<_HandlerResult<T>> wrappedHandler() async {
        try {
          T result = await _handler();
          return _HandlerResult(result, null);
        } catch (e) {
          rethrow;
        }
      }

      // 保存可取消任务，外部调用 cancel 时可以中止等待。
      _cancelableOperation = CancelableOperation.fromFuture(wrappedHandler());
      _HandlerResult<T>? result =
          await _cancelableOperation!.valueOrCancellation();

      if (result == null) {
        throw MetaError("User Cancel", "Operation was cancelled");
      }

      if (result.error != null) {
        throw result.error!;
      }

      _value = result.value;
      return _value as T;
    });
  }

  /// 取消当前正在等待的任务。
  void cancel() {
    _cancelableOperation?.cancel();
  }

  /// 是否已经有缓存结果。
  bool get isDone => _value != null;

  /// 当前是否处于加载执行中。
  bool get isRunning => _lock.locked;

  /// 已完成的缓存值。
  T? get done => _value;
}
