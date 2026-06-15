/// REST 请求异常模型。
///
/// 继承 [RestResponse] 保留服务端响应信息，同时实现本地化错误描述。
import 'package:flutter_foundation_kit/api/RestResponse.dart';
import 'package:flutter_foundation_kit/cutil/Error.dart';

/// 网络请求失败时抛出的统一异常。
class RestRequestError extends RestResponse<dynamic>
    implements Exception, LocalizedError {
  RestRequestError({
    required super.statusCode,
    required super.message,
    required super.data,
    required super.headers,
  });

  String? Function(RestResponse)? _parseErrorHandler;

  /// 设置业务自定义错误文案解析器。
  void setHandler(String? Function(RestResponse) parseErrorHandler) {
    _parseErrorHandler = parseErrorHandler;
  }

  @override
  String get localizedDescription {
    if (_parseErrorHandler != null) {
      try {
        // 优先使用业务侧解析出的错误文案。
        var message = _parseErrorHandler!(this);
        if (message != null) {
          return message;
        }
      } catch (error) {}
    }
    return "Sorry this operation could not be completed. Please try again.";
  }
}
