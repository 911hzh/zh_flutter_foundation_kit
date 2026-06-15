import 'package:flutter_foundation_kit/cutil/Lazyload.dart';
import 'package:flutter_foundation_kit/wcore/store/StoreBase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("StoreBase", () {
    test("test store base", () async {
      final store = TestStore();
      await store.get();
      expect(store.state, 10);
    });
    test("test store base dirty", () {
      final store = TestStore();
      store.dirty();
      expect(store.state, 0);
    });
    test("test store base renew", () {
      final store = TestStore();
      store.renew();
      expect(store.state, 10);
    });
    test("test store base get", () async {
      final store = TestStore();
      var isCalled = false;
      store.addListener(() {
        isCalled = true;
      });
      await store.get();
      expect(isCalled, isTrue);
    });
  });
}

class TestStore extends StoreBase<int> {
  TestStore() : super(0);
  late final _lazyload = Lazyload<int>(() async {
    setState(10);
    return 10;
  });

  @override
  Future<int> get() async {
    return await _lazyload.get();
  }

  @override
  void dirty() {
    setState(0);
    _lazyload.dirty();
  }

  @override
  void renew() {
    _lazyload.renew();
  }
}
