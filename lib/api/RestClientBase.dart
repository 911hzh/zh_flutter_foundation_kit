/// 基于 Dio 的 REST 客户端默认实现。
///
/// 统一封装请求超时、响应解析和 Dio 错误转换。
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_foundation_kit/api/RestRequestError.dart';
import 'package:flutter_foundation_kit/api/RestResponse.dart';
import 'package:flutter_foundation_kit/api/RestClient.dart';

/// 默认 REST 客户端实现。
abstract class RestClientBase extends RestClient {
  /// 底层 Dio 实例，由调用方负责配置 baseUrl、拦截器等。
  Dio dio;

  RestClientBase(this.dio);

  @override
  Future<RestResponse> request(
    String path,
    String method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  }) async {
    try {
      // 所有快捷方法最终都汇聚到这里，确保超时和 header 处理一致。
      var res = await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
          contentType: contentType?.toString(),
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      return _parseResponse(res);
    } catch (error) {
      return _parseError(error);
    }
  }

  @override
  Future<RestResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  }) async {
    return request(
      path,
      "GET",
      queryParameters: queryParameters,
      headers: headers,
      contentType: contentType,
    );
  }

  @override
  Future<RestResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  }) async {
    return request(
      path,
      "POST",
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      contentType: contentType,
    );
  }

  @override
  Future<RestResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  }) async {
    return request(
      path,
      "PUT",
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      contentType: contentType,
    );
  }

  @override
  Future<RestResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  }) async {
    return request(
      path,
      "PATCH",
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      contentType: contentType,
    );
  }

  @override
  Future<RestResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ContentType? contentType,
  }) async {
    return request(
      path,
      "DELETE",
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      contentType: contentType,
    );
  }

  /// 将 Dio 响应转换为基础库统一响应对象。
  Future<RestResponse> _parseResponse(Response response) {
    var headers = <String, String>{};
    response.headers.forEach((name, values) {
      headers.putIfAbsent(name, () => values.first);
    });
    var statusCode = response.statusCode ?? 999;
    var statusMessage = response.statusMessage ?? "";
    var data = response.data;
    if (statusCode >= 200 && statusCode < 300) {
      return Future.value(
        RestResponse(
          statusCode: statusCode,
          message: statusMessage,
          headers: headers,
          data: data,
        ),
      );
    } else {
      // 非 2xx 响应统一转成 RestRequestError，方便业务层按异常路径处理。
      return Future.error(
        RestRequestError(
          statusCode: statusCode,
          message: statusMessage,
          headers: headers,
          data: data,
        ),
      );
    }
  }

  /// 将 DioException 中的响应体继续走统一解析流程。
  Future<RestResponse> _parseError(Object error) {
    if (error is DioException) {
      if (error.response != null) {
        return _parseResponse(error.response!);
      }
    }
    return Future.error(error);
  }
}
