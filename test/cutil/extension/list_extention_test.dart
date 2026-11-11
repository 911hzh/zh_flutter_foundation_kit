import 'package:flutter_foundation_kit/cutil/extension/ListExtention.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  runListExtentionTests();
}

void runListExtentionTests() {
  group("ListExtention", () {
    test("test filterDuplicates no same item", () {
      final list = [1, 2, 3, 4, 5];
      final result = list.filterDuplicates((item) => item);
      expect(result, [1, 2, 3, 4, 5]);
    });
    test("test filterDuplicates with same item", () {
      final list = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 7, 8];
      final result = list.filterDuplicates((item) => item);
      expect(result, [1, 2, 3, 4, 5, 7, 8]);
    });
    test("test getOrNull", () {
      final list = [1, 2, 3, 4, 5];
      final result = list.getOrNull(0);
      expect(result, 1);
      final result1 = list.getOrNull(10);
      expect(result1, null);
    });
    test("test isEqual", () {
      final list = [1, 2, 3, 4, 5];
      final list1 = [1, 2, 3, 4, 5];
      final result = list.isEqual(list1);
      expect(result, true);
      final list2 = [1, 2, 3, 4, 5, 6];
      final result2 = list.isEqual(list2);
      expect(result2, false);
    });
    test("test mapIndex", () {
      final list = [1, 2, 3, 4, 5];
      final result = list.mapIndex((item, index) => item * index);
      expect(result, [0, 2, 6, 12, 20]);
    });
    test("test safeGet", () {
      final list = [1, 2, 3, 4, 5];
      final result = list.safeGet(0);
      expect(result, 1);
      final result1 = list.safeGet(10);
      expect(result1, null);
    });
    test("test htReduce empty list", () {
      List<int> emptyList = [];
      print("emptyList: $emptyList");
      try {
        emptyList.reduce((value, item) => value + item);
        print("emptyList: default reduce start");
        expect(true, isTrue);
      } catch (e) {
        print("emptyList: default reduce end is throw error");
      }

      print("emptyList: htReduce  start");
      final result = emptyList.htReduce(0, (value, item) => value + item);
      print("emptyList: htReduce  end result: $result");
      expect(result, 0);
    });

    test("test htReduce with value", () {
      print("list: computer start");
      final list = [1, 2, 3, 4, 5];
      final result2 = list.htReduce(0, (value, item) => value + item);
      expect(result2, 15);

      final result3 = list.htReduce(2, (value, item) => value + item);
      expect(result3, 17);

      print("list:computer end");
    });
  });
}
