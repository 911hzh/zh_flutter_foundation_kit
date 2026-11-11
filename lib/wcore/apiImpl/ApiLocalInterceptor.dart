import 'package:dio/dio.dart';
import 'package:flutter_foundation_kit/cutil/Generator.dart';
import 'package:flutter_foundation_kit/wcore/apiImpl/ApiClientLogger.dart';

abstract class ApiLocalInterceptor extends Interceptor {
  late final ApiClientLogger _networklogger;
  late final Generator _generator;

  ApiLocalInterceptor(this._networklogger, this._generator);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Future.sync(() async {
      final NetworkData data = NetworkData(
        startTime: DateTime.now(),
        url: options.uri.toString(),
        method: options.method,
      );
      var seq = await _generator.generateId();

      options.extra["networkData"] = data;
      options.extra["seq"] = seq;

      var time = DateTime.now().toString();
      _networklogger.logSimple(
        method: options.method,
        time: time,
        url: options.uri.toString(),
        seq: seq,
      );
      _networklogger.logDetailRequest(
        method: options.method,
        time: time,
        url: options.uri.toString(),
        seq: seq,
        header: options.headers,
        body: options.data,
      );
      handler.next(options);
    });
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final NetworkData data = _map(response);

    var seq = response.requestOptions.extra["seq"] as int;
    _networklogger.logSimple(
      method: data.method,
      time: DateTime.now().toString(),
      url: data.url,
      seq: seq,
      statusCode: "${data.status ?? 999}",
      excuteTime:
          "${DateTime.now().difference(data.startTime).inMilliseconds}ms",
      contentLength: "${data.responseBody.length}",
    );

    _networklogger.logDetailResponse(
      status: "${data.status ?? 999}",
      time: DateTime.now().toString(),
      url: data.url,
      seq: seq,
      response: response,
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    var seq = err.requestOptions.extra["seq"] as int;
    final NetworkData requestData = err.requestOptions.extra["networkData"];
    var msg = err.response?.data.toString() ?? err.message ?? "";
    _networklogger.logSimple(
      method: err.requestOptions.method,
      time: DateTime.now().toString(),
      url: err.requestOptions.uri.toString(),
      seq: seq,
      statusCode: "${err.response?.statusCode ?? 999}",
      excuteTime:
          "${DateTime.now().difference(requestData.startTime).inMilliseconds}ms",
      contentLength: "${msg.length}",
    );

    _networklogger.logDetailResponse(
      status: "${err.response?.statusCode ?? 999}",
      time: DateTime.now().toString(),
      url: err.requestOptions.uri.toString(),
      seq: seq,
      response: err.response,
      errorMsg: msg,
    );

    handler.next(err);
  }

  NetworkData _map(Response<dynamic> response) {
    final NetworkData data = response.requestOptions.extra["networkData"];
    final Map<String, dynamic> responseHeaders = <String, dynamic>{};
    final DateTime endTime = DateTime.now();

    response.headers.forEach(
      (String name, dynamic value) => responseHeaders[name] = value,
    );

    String responseContentType = "";
    if (responseHeaders.containsKey("content-type")) {
      responseContentType = responseHeaders["content-type"].toString();
    }

    int requestBodySize = 0;
    if (response.requestOptions.headers.containsKey("content-length")) {
      requestBodySize = int.parse(
        response.requestOptions.headers["content-length"] ?? "0",
      );
    } else if (response.requestOptions.data != null) {
      requestBodySize = response.requestOptions.data.toString().length;
    }

    int responseBodySize = 0;
    if (responseHeaders.containsKey("content-length")) {
      responseBodySize = int.parse(responseHeaders["content-length"][0] ?? "0");
    } else if (response.data != null) {
      responseBodySize = response.data.toString().length;
    }

    return data.copyWith(
      endTime: endTime,
      duration: endTime.difference(data.startTime).inMicroseconds,
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      requestBody: response.requestOptions.data.toString(),
      requestHeaders: response.requestOptions.headers,
      requestContentType: response.requestOptions.contentType,
      requestBodySize: requestBodySize,
      status: response.statusCode,
      responseBody: response.data.toString(),
      responseHeaders: responseHeaders,
      responseContentType: responseContentType,
      responseBodySize: responseBodySize,
    );
  }
}

class NetworkData {
  NetworkData({
    required this.url,
    required this.method,
    this.requestBody = "",
    this.responseBody = "",
    this.requestBodySize = 0,
    this.responseBodySize = 0,
    this.status,
    this.requestHeaders = const <String, dynamic>{},
    this.responseHeaders = const <String, dynamic>{},
    this.duration,
    this.requestContentType = "",
    this.responseContentType = "",
    this.endTime,
    required this.startTime,
    this.errorCode = 0,
    this.errorDomain = "",
  }) {}

  final String url;
  final String method;
  final String requestBody;
  final String responseBody;
  final int requestBodySize;
  final int responseBodySize;
  final int? status;
  final Map<String, dynamic> requestHeaders;
  final Map<String, dynamic> responseHeaders;
  final int? duration;
  final String? requestContentType;
  final String? responseContentType;
  final DateTime? endTime;
  final DateTime startTime;
  final int errorCode;
  final String errorDomain;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkData &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          method == other.method &&
          requestBody == other.requestBody &&
          responseBody == other.responseBody &&
          requestBodySize == other.requestBodySize &&
          responseBodySize == other.responseBodySize &&
          status == other.status &&
          requestHeaders == other.requestHeaders &&
          responseHeaders == other.responseHeaders &&
          duration == other.duration &&
          requestContentType == other.requestContentType &&
          responseContentType == other.responseContentType &&
          endTime == other.endTime &&
          startTime == other.startTime &&
          errorCode == other.errorCode &&
          errorDomain == other.errorDomain;

  @override
  int get hashCode =>
      url.hashCode ^
      method.hashCode ^
      requestBody.hashCode ^
      responseBody.hashCode ^
      requestBodySize.hashCode ^
      responseBodySize.hashCode ^
      status.hashCode ^
      requestHeaders.hashCode ^
      responseHeaders.hashCode ^
      duration.hashCode ^
      requestContentType.hashCode ^
      responseContentType.hashCode ^
      endTime.hashCode ^
      startTime.hashCode ^
      errorCode.hashCode ^
      errorDomain.hashCode;

  NetworkData copyWith({
    String? url,
    String? method,
    String? requestBody,
    String? responseBody,
    int? requestBodySize,
    int? responseBodySize,
    int? status,
    Map<String, dynamic>? requestHeaders,
    Map<String, dynamic>? responseHeaders,
    int? duration,
    String? requestContentType,
    String? responseContentType,
    DateTime? endTime,
    DateTime? startTime,
    int? errorCode,
    String? errorDomain,
  }) {
    return NetworkData(
      url: url ?? this.url,
      method: method ?? this.method,
      requestBody: requestBody ?? this.requestBody,
      responseBody: responseBody ?? this.responseBody,
      requestBodySize: requestBodySize ?? this.requestBodySize,
      responseBodySize: responseBodySize ?? this.responseBodySize,
      status: status ?? this.status,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      duration: duration ?? this.duration,
      requestContentType: requestContentType ?? this.requestContentType,
      responseContentType: responseContentType ?? this.responseContentType,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      errorCode: errorCode ?? this.errorCode,
      errorDomain: errorDomain ?? this.errorDomain,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "method": method,
      "requestBody": requestBody,
      "responseBody": responseBody,
      "responseCode": status,
      "requestHeaders": requestHeaders.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      "responseHeaders": responseHeaders.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      "requestContentType": requestContentType,
      "responseContentType": responseContentType,
      "duration": duration,
      "startTime": startTime.millisecondsSinceEpoch,
      "requestBodySize": requestBodySize,
      "responseBodySize": responseBodySize,
      "errorDomain": errorDomain,
      "errorCode": errorCode,
    };
  }
}
