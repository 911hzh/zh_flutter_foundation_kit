import "package:flutter_foundation_kit/flutter_foundation_kit.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  runLazyloadTests();
}

void runLazyloadTests() {
  group("Lazyload", () {
    test("get caches handler result", () async {
      var callCount = 0;
      final lazyload = Lazyload<int>(() async {
        callCount += 1;
        return callCount;
      });

      final first = await lazyload.get();
      final second = await lazyload.get();

      expect(first, 1);
      expect(second, 1);
      expect(callCount, 1);
      expect(lazyload.isDone, isTrue);
      expect(lazyload.done, 1);
    });

    test("dirty clears cached value", () async {
      var callCount = 0;
      final lazyload = Lazyload<int>(() async {
        callCount += 1;
        return callCount;
      });

      expect(await lazyload.get(), 1);

      lazyload.dirty();

      expect(lazyload.isDone, isFalse);
      expect(await lazyload.get(), 2);
      expect(callCount, 2);
    });

    test("renew refreshes cached value immediately", () async {
      var callCount = 0;
      final lazyload = Lazyload<int>(() async {
        callCount += 1;
        return callCount;
      });

      expect(await lazyload.get(), 1);
      expect(await lazyload.renew(), 2);
      expect(await lazyload.get(), 2);
      expect(callCount, 2);
    });
  });
}
