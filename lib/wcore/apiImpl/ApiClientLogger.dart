/*
《代码文档》

## 概述
- api层日志打印功能，用于打印api请求和响应的日志
- 日志分为两类：
  - 简单日志：只打印请求的url、方法、状态码、执行时间
  - 详细日志：打印请求的url、方法、状态码、执行时间、请求头、请求体、响应体
*/
import 'package:dio/dio.dart';
import 'package:flutter_foundation_kit/cutil/JsonUtil.dart';
import 'package:flutter_foundation_kit/wcore/logger/LoggerFactory.dart';

class ApiClientLogger {
  static String simpleLoggerName = "api_simple";
  static String detailLoggerName = "api_detail";

  final _simpleLogger = LoggerFactory.current.getLogger(["api_simple"]);
  final _detailLogger = LoggerFactory.current.getLogger(["api_detail"]);

  String _format({required String log, required int totalLength}) {
    var temp = log;
    if (totalLength <= temp.length) {
      return temp;
    }

    for (var i = 0; i <= totalLength - log.length; i++) {
      temp = "${temp} ";
    }

    return temp;
  }

  void logSimple({
    required String method,
    required String time,
    required String url,
    required int seq,
    String statusCode = "-",
    String excuteTime = "-",
    String contentLength = "-",
  }) {
    var seqStr = _format(log: "#$seq", totalLength: 6);
    var methodStr = _format(log: method, totalLength: 8);
    var statusCodeStr = _format(log: statusCode, totalLength: 6);
    var excuteTimeStr = _format(log: excuteTime, totalLength: 15);
    var contentLengthStr = _format(log: contentLength, totalLength: 10);
    var msg =
        "> ${time.substring(0, 23)}   " +
        seqStr +
        methodStr +
        statusCodeStr +
        excuteTimeStr +
        contentLengthStr +
        "${url}";

    _simpleLogger.info(msg);
  }

  void logDetailRequest({
    required String method,
    required String time,
    required String url,
    required int seq,
    required Map<String, dynamic> header,
    required dynamic body,
  }) {
    var seqStr = "#$seq";
    var msg = "> ${time.substring(0, 23)} $seqStr $method $url\n";

    var copyHeader = JsonUtil.clone(header);
    if (copyHeader["Authorization"] != null) {
      copyHeader["Authorization"] = "xxx";
    }
    msg = msg + "header: ${JsonUtil.stringify(copyHeader)}\n";

    var bodyTxt = "body: ";
    if (body != null && method != "GET") {
      if (body is Map) {
        bodyTxt = bodyTxt + "${JsonUtil.stringify(body)}";
      } else {
        bodyTxt = bodyTxt + "\"${body.toString()}\"";
      }
    }
    msg = msg + bodyTxt + "\n\n\n";
    _detailLogger.info(msg);
  }

  void logDetailResponse({
    required String status,
    required String time,
    required String url,
    required int seq,
    required Response? response,
    String? responseText = null,
    String? errorMsg = null,
  }) {
    var seqStr = "#$seq";
    var msg = "> ${time.substring(0, 23)} $seqStr $status $url";

    if (response != null && response.data != null) {
      if (response.data is Map) {
        var body = JsonUtil.stringify(response.data);
        _detailLogger.info("$msg\nresponse: $body\n\n\n");
      } else if (response is String) {
        var bodyTxt = response.data.toString();
        bodyTxt = bodyTxt.replaceAll("\n", "");
        _detailLogger.info("$msg\nresponse: $bodyTxt\n\n\n");
      } else {
        // 是stream response，在其他地方记录
      }
    } else if (responseText != null) {
      _detailLogger.info("$msg\nresponse: $responseText\n\n\n");
    } else if (errorMsg != null) {
      _detailLogger.info("$msg\nerror: $errorMsg\n\n\n");
    }
  }
}
