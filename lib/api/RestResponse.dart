/// REST 请求响应模型和转换扩展。
///
/// 用于把原始响应数据转换成业务模型或 Map。
import 'package:flutter/foundation.dart';
import 'package:flutter_foundation_kit/cutil/JsonUtil.dart';

/// REST 请求响应数据。
class RestResponse<T> {
  /// HTTP 状态码。
  final int statusCode;

  /// HTTP 状态描述。
  final String message;

  /// 响应体。
  final T data;

  /// 响应头。
  final Map<String, String> headers;

  RestResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.headers,
  });

  /// 是否为 2xx 成功响应。
  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}

/// Future 响应转换扩展。
extension RestResponseExtension on Future<RestResponse> {
  /// 将响应体解析成业务模型。
  Future<RestResponse<T>> toModel<T>(T Function(Map<String, dynamic>) parser) {
    return then((value) {
      dynamic data = value.data;
      if (data is String) data = JsonUtil.parse(data);
      if (data is Map<String, dynamic>) data = parser(data);
      // 这里保持原有返回结构，仅提供统一转换入口。
      return RestResponse<T>(
        statusCode: value.statusCode,
        message: value.message,
        data: data,
        headers: value.headers,
      );
    });
  }

  /// 在子线程中将字符串响应体解析成业务模型。
  Future<RestResponse<T>> toModelSubThread<T>(
    T Function(Map<String, dynamic>) parser,
  ) {
    return then((value) async {
      final data = value.data;
      if (data is String) {
        final result = await compute((data) {
          final json = JsonUtil.parse(data);
          if (json != null) {
            return parser(json);
          }
          throw Exception("data is not a valid json");
        }, data);
        return RestResponse<T>(
          statusCode: value.statusCode,
          message: value.message,
          data: result,
          headers: value.headers,
        );
      }
      if (data is Map<String, dynamic>) {
        final result = parser(data);
        return RestResponse<T>(
          statusCode: value.statusCode,
          message: value.message,
          data: result,
          headers: value.headers,
        );
      }
      throw Exception("data is not a string");
    });
  }

  /// 将响应体转换成 JSON Map。
  Future<RestResponse<Map<String, dynamic>>> toMap() {
    return then((value) {
      var data = value.data;
      if (data is String) {
        data = JsonUtil.parse(data) ?? {};
      } else if (data is Map<String, dynamic>) {
        data = data;
      }
      return RestResponse<Map<String, dynamic>>(
        statusCode: value.statusCode,
        message: value.message,
        data: data,
        headers: value.headers,
      );
    });
  }

  /// 从响应 Map 中提取业务模型。
  Future<RestResponse<T>> extractModel<T>(
    T Function(Map<String, dynamic>) parser,
  ) {
    return toMap().then((value) {
      final data = value.data;
      final result = parser(data);
      return RestResponse(
        statusCode: value.statusCode,
        message: value.message,
        data: result,
        headers: value.headers,
      );
    });
  }

  /// 在子线程中从响应体提取业务模型。
  Future<RestResponse<T>> extractModelSubThread<T>(
    T Function(Map<String, dynamic>) parser,
  ) {
    return then((value) async {
      final data = value.data;
      final result = await compute((data) {
        Map<String, dynamic>? map;
        if (data is String) {
          map = JsonUtil.parse(data);
        } else if (data is Map<String, dynamic>) {
          map = data;
        }
        if (map == null) {
          throw Exception("data is not a valid json");
        }
        return parser(map);
      }, data);
      return RestResponse<T>(
        statusCode: value.statusCode,
        message: value.message,
        data: result,
        headers: value.headers,
      );
    });
  }
}
