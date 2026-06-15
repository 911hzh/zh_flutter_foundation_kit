/// REST 请求客户端协议。
///
/// 定义基础 HTTP 方法，具体实现负责选择底层网络库和错误转换方式。
import 'dart:io';

import 'package:flutter_foundation_kit/api/RestResponse.dart';

/// 业务侧依赖的网络请求抽象。
abstract class RestClient {
  /// 发起一个通用 HTTP 请求。
  Future<RestResponse> request(
    String path,
    String method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  });

  /// 发起 GET 请求。
  Future<RestResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  });

  /// 发起 POST 请求。
  Future<RestResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  });

  /// 发起 PUT 请求。
  Future<RestResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  });

  /// 发起 PATCH 请求。
  Future<RestResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  });

  /// 发起 DELETE 请求。
  Future<RestResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  });
}
