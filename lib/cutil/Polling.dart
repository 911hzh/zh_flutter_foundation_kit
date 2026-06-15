/// 轮询任务工具。
///
/// 基于 [Lazyload] 执行异步任务，并按固定间隔重复触发。
import "dart:async";
import "package:flutter_foundation_kit/cutil/Lazyload.dart";

/// 定时轮询控制器。
class Polling<T> {
  bool _stopStatus = false;

  /// 两次轮询之间的间隔，单位为毫秒。
  num spaceTime;

  /// 当前定时器。
  Timer? timer;

  /// 每次轮询执行的任务。
  Lazyload<T> task;

  /// 最大轮询次数，0 表示不限制。
  int pollingCount;

  /// 当前已经执行的轮询次数。
  int currentPollingCount = 0;

  /// 每次任务完成后的回调。
  void Function(T result) callBack;

  Polling({
    required this.spaceTime,
    required this.task,
    required this.callBack,
    this.pollingCount = 0,
  });

  /// 启动轮询。
  void start() {
    _stopStatus = false;
    currentPollingCount = 0;
    _executeTask();
  }

  /// 执行一次任务，并在需要时安排下一次轮询。
  _executeTask() async {
    task.dirty();
    final result = await task.get();
    currentPollingCount++;
    if (_stopStatus) {
      timer?.cancel();
      return;
    }

    timer?.cancel();
    // 每次任务完成后重新创建定时器，避免任务执行耗时挤压间隔。
    timer = Timer(Duration(milliseconds: spaceTime.toInt()), () {
      if (_stopStatus) {
        return;
      }
      _executeTask();
    });
    callBack(result);
    if (pollingCount > 0 && currentPollingCount >= pollingCount) {
      _stopStatus = true;
    }
  }

  /// 停止轮询并取消定时器。
  void stop() {
    _stopStatus = true;
    timer?.cancel();
  }
}
