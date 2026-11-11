import 'package:flutter_foundation_kit/cutil/Lazyload.dart';
import 'package:flutter_foundation_kit/cutil/Polling.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  runPollingTests();
}

void runPollingTests() {
  group("Polling", () {
    test("test pollingCount", () async {
      var callCount = 0;
      final polling = Polling(
        spaceTime: 500,
        pollingCount: 3,
        task: Lazyload<int>(() async {
          print("execute task");
          return callCount++;
        }),
        callBack: (result) {
          print(result);
        },
      );
      polling.start();
      await Future.delayed(Duration(milliseconds: 2000));
      expect(callCount, 3);
      polling.stop();
      print("fist polling stop");

      callCount = 0;
      final polling1 = Polling(
        spaceTime: 500,
        pollingCount: 4,
        task: Lazyload<int>(() async {
          callCount++;
          print("execute task :${callCount}");
          return callCount;
        }),
        callBack: (result) {
          print(result);
        },
      );
      polling1.start();
      await Future.delayed(Duration(milliseconds: 2500));
      expect(callCount, 4);
      polling1.stop();
      print("second polling stop");
    });
  });
}
