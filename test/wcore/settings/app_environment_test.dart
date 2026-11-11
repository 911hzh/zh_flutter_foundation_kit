import 'package:flutter_foundation_kit/wcore/settings/AppEnvironment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AppEnvironment", () {
    test("compares environments by name", () {
      expect(AppEnvironment("development"), AppEnvironment.development);
      expect(AppEnvironment("production"), AppEnvironment.production);
      expect(AppEnvironment("staging"), isNot(AppEnvironment.production));
    });

    test("uses name as string representation", () {
      expect(AppEnvironment.test.name, "test");
      expect(AppEnvironment("staging").toString(), "staging");
    });
  });
}
