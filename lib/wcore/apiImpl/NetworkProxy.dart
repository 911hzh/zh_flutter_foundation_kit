import 'dart:async';

abstract class NetworkProxy {
  String? proxyIp;
  NetworkProxy({required this.proxyIp}) {
    if (proxyIp == null) {
      // proxyIp = getSystemAddress();
    }
    _proxyChanged.add(proxyIp);
  }

  /// 代理变化事件
  final _proxyChanged = StreamController<String?>.broadcast();

  String? findProxy() {
    final proxy = proxyIp?.trim();
    if (proxy == null || proxy.isEmpty) {
      return proxy;
    }

    final proxyRule = proxy.toUpperCase();
    if (proxyRule.startsWith('PROXY ') || proxyRule == 'DIRECT') {
      return proxy;
    }

    return 'PROXY $proxy';
  }

  String? getSystemAddress() {
    // var result = await runFuture(SystemProxy.getProxySettings());
    // if (result.ok == null) {
    //   return null;
    // }
    //
    // var proxy = result.ok!;
    // var host = proxy["host"];
    // var port = proxy["port"];
    // return "PROXY $host:$port";
    return null;
  }

  Stream<String?> get proxyChanged => _proxyChanged.stream;

  void setProxy(String? proxy) {
    if (proxy == proxyIp) {
      return;
    }
    proxyIp = proxy;
    _proxyChanged.add(proxy);
  }
}
