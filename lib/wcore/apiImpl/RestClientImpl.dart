import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_foundation_kit/api/RestClientBase.dart';
import 'package:flutter_foundation_kit/wcore/apiImpl/NetworkProxy.dart';
import 'package:flutter_foundation_kit/wcore/apiImpl/RestClientAdapter.dart';

class RestClientImpl extends RestClientBase {
  RestClientImpl({
    required RestClientAdapter restAdapter,
    required NetworkProxy networkProxy,
    List<Interceptor> interceptors = const [],
    IOHttpClientAdapter Function(NetworkProxy networkProxy)? createHttpClientAdapter,
  }) : super(Dio()) {
    dio.options.baseUrl = restAdapter.getBaseUrl();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await restAdapter.onRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (e, handler) {
          restAdapter.onError(e);
          return handler.next(e);
        },
      ),
    );
    if (createHttpClientAdapter != null) {
      dio.httpClientAdapter = createHttpClientAdapter(networkProxy);
    }
  }

  // 创建HttpClientAdapter

  // IOHttpClientAdapter _createHttpClientAdapter({required NetworkProxy networkProxy}) {
  //   return IOHttpClientAdapter(
  //     createHttpClient: () {
  //       final client = HttpClient();
  //       client.badCertificateCallback = (X509Certificate cert, String host, int port) {
  //         return true;
  //       };

  //       var proxy = networkProxy.findProxy();
  //       if (proxy != null && proxy.isNotEmpty) {
  //         client.findProxy = (uri) {
  //           return proxy;
  //         };
  //       }
  //       return client;
  //     },
  //   );
  // }
}
