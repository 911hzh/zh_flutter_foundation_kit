import 'package:flutter_foundation_kit/wcore/apiImpl/NetworkProxy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkProxy', () {
    test('formats host and port as HttpClient proxy rule', () {
      final proxy = TestNetworkProxy(proxyIp: '192.168.1.73:9090');

      expect(proxy.findProxy(), 'PROXY 192.168.1.73:9090');
    });

    test('keeps existing HttpClient proxy rule', () {
      final proxy = TestNetworkProxy(proxyIp: 'PROXY 127.0.0.1:8888');

      expect(proxy.findProxy(), 'PROXY 127.0.0.1:8888');
    });

    test('keeps direct proxy rule', () {
      final proxy = TestNetworkProxy(proxyIp: 'DIRECT');

      expect(proxy.findProxy(), 'DIRECT');
    });
  });
}

class TestNetworkProxy extends NetworkProxy {
  TestNetworkProxy({required super.proxyIp});
}
