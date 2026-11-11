import 'package:dio/dio.dart';

abstract class RestClientAdapter {
  RestClientAdapter();

  String getBaseUrl();

  Future<Map<String, String>> getHeaders() async {
    var headers = <String, String>{};
    return headers;
  }

  Future<void> onRequest(RequestOptions options) async {
    var headers = await getHeaders();
    final keys = options.headers.keys.map((e) => e.toLowerCase()).toList();
    //  调用者传入了key，就以调用者传入的为准。
    headers.entries.forEach((element) {
      if (!keys.contains(element.key.toLowerCase())) {
        options.headers.addEntries([element]);
      }
    });
  }

  Future<void> onError(DioException error) async {
    // var statusCode = error.response?.statusCode ?? 999;
    // if ([401].contains(statusCode) && authStore.state.token.isNotEmpty) {
    //   authStore.emit(authStore.state.copyWith(token: ""));
    //   eventbus.emit(UnauthorizedMsg(statusCode));
    // }
  }
}
