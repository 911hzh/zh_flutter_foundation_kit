import 'package:dio/dio.dart';
import 'package:flutter_foundation_kit/api/RestRequestError.dart';
import 'package:flutter_foundation_kit/wcore/apiImpl/NetworkProxy.dart';
import 'package:flutter_foundation_kit/wcore/apiImpl/RestClientAdapter.dart';
import 'package:flutter_foundation_kit/wcore/apiImpl/RestClientImpl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("RestClientImpl", () {
    test("sets dio baseUrl from adapter", () {
      final restClient = RestClientImpl(
        restAdapter: TestRestClientAdapter(),
        networkProxy: TestNetworkProxy(proxyIp: null),
      );
      expect(restClient.dio, isNotNull);
      expect(restClient.dio.options.baseUrl, "https://httpbingo.org");
    });

    test("calls real api and merges adapter headers into request", () async {
      final restClient = RestClientImpl(
        restAdapter: TestRestClientAdapter(
          headers: {"X-Test-Header": "adapter-token"},
        ),
        networkProxy: TestNetworkProxy(proxyIp: null),
      );

      final response = await restClient.get(
        "/get",
        queryParameters: {"source": "rest_client_impl_test"},
      );
      final data = response.data as Map<String, dynamic>;
      final headers = data["headers"] as Map<String, dynamic>;
      final args = data["args"] as Map<String, dynamic>;

      expect(response.statusCode, 200);
      expect(headers["X-Test-Header"], ["adapter-token"]);
      expect(args["source"], ["rest_client_impl_test"]);
    });

    test("keeps request header when adapter provides same header", () async {
      final restClient = RestClientImpl(
        restAdapter: TestRestClientAdapter(
          headers: {"X-Test-Header": "adapter-token"},
        ),
        networkProxy: TestNetworkProxy(proxyIp: null),
      );

      final response = await restClient.get(
        "/get",
        headers: {"X-Test-Header": "request-token"},
      );
      final data = response.data as Map<String, dynamic>;
      final headers = data["headers"] as Map<String, dynamic>;

      expect(headers["X-Test-Header"], ["request-token"]);
    });

    test("notifies adapter when request fails", () async {
      final restAdapter = TestRestClientAdapter();
      final restClient = RestClientImpl(
        restAdapter: restAdapter,
        networkProxy: TestNetworkProxy(proxyIp: null),
      );

      await expectLater(
        restClient.get("/status/500"),
        throwsA(isA<RestRequestError>()),
      );

      expect(restAdapter.errorCount, 1);
      expect(restAdapter.lastError?.response?.statusCode, 500);
    });
  });
}

class TestRestClientAdapter extends RestClientAdapter {
  TestRestClientAdapter({this.headers = const {}});

  final Map<String, String> headers;
  int errorCount = 0;
  DioException? lastError;

  @override
  String getBaseUrl() {
    return "https://httpbingo.org";
  }

  @override
  Future<Map<String, String>> getHeaders() async {
    return headers;
  }

  @override
  Future<void> onError(DioException error) async {
    errorCount += 1;
    lastError = error;
  }
}

class TestNetworkProxy extends NetworkProxy {
  TestNetworkProxy({required super.proxyIp});
  @override
  String? findProxy() {
    return null;
  }
}
