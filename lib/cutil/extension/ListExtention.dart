/// 集合相关扩展方法。
///
/// 提供去重、安全访问、带索引映射和列表比较等常用能力。
/// 文件名沿用历史拼写 `Extention`，对外 API 暂不改名以避免破坏引用。
/// 基础列表扩展。
extension ListExtention<E, K> on List<E> {
  /// 根据 [filter] 生成的 key 对列表元素去重。
  List<E> filterDuplicates(K Function(E) filter) {
    Set<K> uniqueSet = Set<K>();
    List<E> newResult = [];
    forEach((element) {
      // 保留首次出现的 key，后续重复 key 会被跳过。
      var key = filter(element);
      if (!uniqueSet.contains(key)) {
        newResult.add(element);
        uniqueSet.add(key);
      }
    });
    return newResult;
  }

  /// 安全读取指定下标，越界时返回 null。
  E? getOrNull(idx) {
    if (idx < length) {
      return this[idx];
    }
    return null;
  }
}

/// Iterable 归约扩展。
extension IterableExention<E> on Iterable<E> {
  /// 从 [initValue] 开始依次合并元素。
  Value htReduce<Value>(
    Value initValue,
    Value combine(Value value, E element),
  ) {
    Iterator<E> iterator = this.iterator;
    Value value = initValue;
    while (iterator.moveNext()) {
      value = combine(value, iterator.current);
    }
    return value;
  }
}

/// 列表安全访问扩展。
extension SafeListAccess<T> on List<T> {
  /// 通过扩展方法安全访问列表元素，超出范围时返回 null。
  T? safeGet(int index) {
    return (index >= 0 && index < length) ? this[index] : null;
  }
}

/// 带下标映射扩展。
extension MapIndexed<E> on List<E> {
  /// 将元素和下标一起传入 [f] 进行映射。
  Iterable<T> mapIndex<T>(T Function(E element, int index) f) {
    return asMap().entries.map((entry) => f(entry.value, entry.key));
  }
}

/// 列表相等比较扩展。
extension EqualsExtention<E> on List<E> {
  /// 判断两个列表长度和每个位置的元素是否相等。
  bool isEqual(List<E> other) {
    if (length != other.length) {
      return false;
    }
    for (int i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
