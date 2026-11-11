import "package:flutter_foundation_kit/flutter_foundation_kit.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  runJsonUtilTests();
}

void runJsonUtilTests() {
  group("JsonUtil", () {
    test("parse returns map for valid json", () {
      final result = JsonUtil.parse('{"name":"flutter","count":1}');

      expect(result, {"name": "flutter", "count": 1});
    });

    test("parse returns null for invalid json", () {
      final result = JsonUtil.parse("{invalid json}");

      expect(result, isNull);
    });

    test("pretty formats valid json", () {
      final result = JsonUtil.pretty('{"name":"flutter","count":1}');

      expect(result, '{\n  "name": "flutter",\n  "count": 1\n}');
    });

    test("clone creates a deep copy", () {
      final source = {
        "user": {"name": "flutter"},
      };

      final result = JsonUtil.clone(source);
      (result["user"] as Map<String, dynamic>)["name"] = "dart";

      expect((source["user"] as Map<String, dynamic>)["name"], "flutter");
      expect((result["user"] as Map<String, dynamic>)["name"], "dart");
    });
  });
}
