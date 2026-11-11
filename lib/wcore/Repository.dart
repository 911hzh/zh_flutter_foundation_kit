/// 仓储抽象定义。
///
/// 用于描述按 key 读写 value 的最小数据访问协议。
/// 通用数据仓储抽象。
///
/// [K] 表示单次读写的数据索引 key 类型，[V] 表示单次读写的 value 类型。
abstract class Repository {
  /// 当前仓储对应的存储空间名称。
  final String boxName;

  Repository(this.boxName);

  /// 写入指定 [key] 对应的 [value]。
  Future<void> setValue<K, V>(K key, V? value);

  /// 读取指定 [key] 对应的值。
  Future<V?> getValue<K, V>(K key);

  Future<void> delete<K>(K key);
}
