import 'package:flutter_foundation_kit/cutil/Generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  runGeneratorTests();
}

void runGeneratorTests() {
  group("Generator", () {
    test("test generateId", () async {
      final id1 = await Generator.instance.generateId();
      final id2 = await Generator.instance.generateId();
      expect(id1, 1);
      expect(id2, 2);
      final id3 = await Generator.instance.generateId();
      expect(id3, 3);
    });
  });
}
