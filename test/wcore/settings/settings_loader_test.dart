import 'package:flutter_foundation_kit/wcore/settings/AppEnvironment.dart';
import 'package:flutter_test/flutter_test.dart';

import 'settings_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("SettingsLoader", () {
    test("loads development settings and injects runtime metadata", () async {
      const loader = TestSettingsLoader(
        packageName: TestSettingsLoader.developmentPackageName,
      );

      final settings = await loader.getSettings(builder: AppSettings.fromJson);

      expect(settings.packageName, TestSettingsLoader.developmentPackageName);
      expect(settings.environment, AppEnvironment.development);
      expect(settings.baseUrl, "https://dev-api.example.com");
      expect(settings.instabugToken, "development-instabug-token");
    });

    test("loads production settings from package environment", () async {
      const loader = TestSettingsLoader(
        packageName: TestSettingsLoader.releasePackageName,
      );

      final settings = await loader.getSettings(builder: AppSettings.fromJson);

      expect(settings.packageName, TestSettingsLoader.releasePackageName);
      expect(settings.environment, AppEnvironment.production);
      expect(settings.baseUrl, "https://api.example.com");
      expect(settings.instabugToken, "release-instabug-token");
    });

    test("applies overrides before building settings", () async {
      const loader = TestSettingsLoader(
        packageName: TestSettingsLoader.developmentPackageName,
      );

      final settings = await loader.getSettings(
        builder: AppSettings.fromJson,
        overrides: const {"baseUrl": "https://override.example.com"},
      );

      expect(settings.baseUrl, "https://override.example.com");
      expect(settings.environment, AppEnvironment.development);
    });
  });
}
