/// JSON 编解码协议。
///
/// 实现类通过 [toJson] 输出 JSON Map，并通过 `fromJson` 工厂构造自身。
abstract class Codable {
  const Codable();

  /// 将当前对象转换为 JSON Map。
  Map<String, dynamic> toJson() => <String, dynamic>{};

  /// 从 JSON Map 创建对象。
  factory Codable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
