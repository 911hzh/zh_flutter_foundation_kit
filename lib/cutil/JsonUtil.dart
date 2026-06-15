/// JSON 编解码工具。
///
/// 提供同步和 isolate 异步版本，便于在大 JSON 场景下降低主线程压力。
import "dart:convert";
import "package:flutter/foundation.dart";

/// JSON 工具类。
class JsonUtil {
  /// 将对象编码为 JSON 字符串。
  static String stringify(Object? object, {bool pretty = false}) {
    if (pretty) {
      return const JsonEncoder.withIndent("  ").convert(object);
    } else {
      return jsonEncode(object);
    }
  }

  /// 将 JSON 字符串解析为 Map，失败时返回 null。
  static Map<String, dynamic>? parse(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      return null;
    }
  }

  /// 将 JSON 数组字符串解析为 Map 列表，失败时返回 null。
  static List<Map<String, dynamic>>? parseList(String source) {
    try {
      return (jsonDecode(source) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// 在 isolate 中解析 JSON Map，失败时返回 null。
  static Future<Map<String, dynamic>?> parseAsync(String source) async {
    var params = source;
    try {
      // compute 会把解析工作放到后台 isolate，避免阻塞 UI。
      return await compute((params) {
        return jsonDecode(params);
      }, params);
    } catch (e) {
      debugPrint("parse json error: $e");
      return null;
    }
  }

  /// 将 JSON 字符串格式化输出，解析失败时返回原内容。
  static String pretty(String content) {
    var map = JsonUtil.parse(content);
    if (map == null) return content;
    return JsonUtil.stringify(map, pretty: true);
  }

  /// 在 isolate 中格式化 JSON 字符串。
  static Future<String> prettyAsync(String content) {
    var params = content;
    return compute((params) {
      var map = JsonUtil.parse(params);
      if (map == null) return params;
      return JsonUtil.stringify(map, pretty: true);
    }, params);
  }

  /// 通过 JSON 编解码深拷贝 Map。
  static Map<String, dynamic> clone(Map<String, dynamic> map) {
    return jsonDecode(jsonEncode(map));
  }

  /// 在 isolate 中深拷贝 Map。
  static Future<Map<String, dynamic>> cloneAsync(Map<String, dynamic> map) {
    var params = map;

    return compute((params) {
      return jsonDecode(jsonEncode(params));
    }, params);
  }
}
